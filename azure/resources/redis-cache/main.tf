#------------------------------------------------------------
# Local configuration - Default (required).
#------------------------------------------------------------
terraform {
    required_providers {
      azurerm = {
        configuration_aliases = [azurerm.hub]
    }
  }
}

locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rg.*.name, azurerm_resource_group.default.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rg.*.location, [var.location]), 0)
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "default" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = local.location
  tags     = merge({ "Name" = format("%s", var.resource_group_name) }, var.tags, )
}

data "azurerm_log_analytics_workspace" "logws" {
  count               = var.log_analytics_workspace_name != null ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = local.resource_group_name
}

#---------------------------------------------------------------
# Storage Account to keep logs and backups - Default is "false"
#----------------------------------------------------------------

resource "random_string" "default" {
  count   = var.enable_data_persistence ? 1 : 0
  length  = 6
  special = false
  upper   = false
  keepers = {
    name = var.storage_account_name
  }
}

resource "azurerm_storage_account" "default" {
  #  for_each                  = var.redis_configuration != {} ? { for rdb_backup_enabled, v in var.redis_configuration : rdb_backup_enabled => v if v == true } : null
  count                     = var.enable_data_persistence ? 1 : 0
  name                      = var.storage_account_name == null ? "rediscachebkpstore${random_string.default.0.result}" : substr(var.storage_account_name, 0, 24)
  resource_group_name       = local.resource_group_name
  location                  = local.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  tags                      = merge({ "Name" = format("%s", "stsqlauditlogs") }, var.tags, )
}

#------------------------------------------------------------
# Redis Cache Instance configuration - Default (required).
#------------------------------------------------------------

resource "azurerm_redis_cache" "default" {
  for_each                      = var.redis_server_settings
  name                          = lower(format("%s-%s-%s", each.key, var.teamname, var.env))
  resource_group_name           = local.resource_group_name
  location                      = local.location
  capacity                      = each.value["capacity"]
  family                        = lookup(var.redis_family, each.value.sku_name)
  sku_name                      = each.value["sku_name"]
  enable_non_ssl_port           = each.value["enable_non_ssl_port"]
  minimum_tls_version           = each.value["minimum_tls_version"]
  private_static_ip_address     = each.value["private_static_ip_address"]
  public_network_access_enabled = each.value["public_network_access_enabled"] == null ? false : each.value["public_network_access_enabled"]
  replicas_per_master           = each.value["sku_name"] == "Premium" ? each.value["replicas_per_master"] : null
  shard_count                   = each.value["sku_name"] == "Premium" ? each.value["shard_count"] : null
  subnet_id                     = each.value["sku_name"] == "Premium" ? var.subnet_id : null
  zones                         = each.value["zones"]
  tags                          = merge({ "Name" = format("%s", each.key) }, var.tags, )

  dynamic "redis_configuration" {
    for_each = var.redis_configuration != {} ? [var.redis_configuration] : []
    content {
      #  aof_backup_enabled              = var.enable_aof_backup
      #  aof_storage_connection_string_0 = var.enable_aof_backup == true ? azurerm_storage_account.storeacc.0.primary_blob_connection_string : null
      #  aof_storage_connection_string_1 = var.enable_aof_backup == true ? azurerm_storage_account.storeacc.0.secondary_blob_connection_string : null
      enable_authentication           = lookup(var.redis_configuration, "enable_authentication", true)
      maxfragmentationmemory_reserved = each.value["sku_name"] == "Premium" || each.value["sku_name"] == "Standard" ? lookup(var.redis_configuration, "maxfragmentationmemory_reserved") : null
      maxmemory_delta                 = each.value["sku_name"] == "Premium" || each.value["sku_name"] == "Standard" ? lookup(var.redis_configuration, "maxmemory_delta") : null
      maxmemory_policy                = lookup(var.redis_configuration, "maxmemory_policy")
      maxmemory_reserved              = each.value["sku_name"] == "Premium" || each.value["sku_name"] == "Standard" ? lookup(var.redis_configuration, "maxmemory_reserved") : null
      notify_keyspace_events          = lookup(var.redis_configuration, "notify_keyspace_events")
      rdb_backup_enabled              = each.value["sku_name"] == "Premium" && var.enable_data_persistence == true ? true : false
      rdb_backup_frequency            = each.value["sku_name"] == "Premium" && var.enable_data_persistence == true ? var.data_persistence_backup_frequency : null
      rdb_backup_max_snapshot_count   = each.value["sku_name"] == "Premium" && var.enable_data_persistence == true ? var.data_persistence_backup_max_snapshot_count : null
      rdb_storage_connection_string   = each.value["sku_name"] == "Premium" && var.enable_data_persistence == true ? azurerm_storage_account.default.0.primary_blob_connection_string : null
    }
  }

  dynamic "patch_schedule" {
    for_each = var.patch_schedule != null ? [var.patch_schedule] : []
    content {
      day_of_week    = var.patch_schedule.day_of_week
      start_hour_utc = var.patch_schedule.start_hour_utc
    }
  }

  lifecycle {
    # A bug in the Redis API where the original storage connection string isn't being returneds
    ignore_changes = [redis_configuration.0.rdb_storage_connection_string]
  }
}

#----------------------------------------------------------------------
# Adding Firewall rules for Redis Cache Instance - Default is "false"
#----------------------------------------------------------------------
resource "azurerm_redis_firewall_rule" "default" {
  for_each            = var.firewall_rules != null ? { for k, v in var.firewall_rules : k => v if v != null } : {}
  name                = format("%s", each.key)
  redis_cache_name    = element([for n in azurerm_redis_cache.default : n.name], 0)
  resource_group_name = local.resource_group_name
  start_ip            = each.value["start_ip"]
  end_ip              = each.value["end_ip"]
}

#------------------------------------------------------------------
# azurerm monitoring diagnostics  - Default is "false"
#------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "default" {
  count                      = var.log_analytics_workspace_name != null ? 1 : 0
  name                       = lower("redismonitor-${element([for n in azurerm_redis_cache.default : n.name], 0)}-${var.teamname}-diag")
  target_resource_id         = element([for i in azurerm_redis_cache.default : i.id], 0)
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logws.0.id
  storage_account_id         = var.enable_data_persistence ? azurerm_storage_account.default.0.id : null

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

  lifecycle {
    ignore_changes = [metric]
  }
}


#------------------------------------------------------------------
# private link
#------------------------------------------------------------------

module "privatelink" {
  providers = {
    azurerm.hub = azurerm.hub
  }
  depends_on = [azurerm_redis_cache.default]
  source = "../privatelink"
  location = local.location

  for_each = var.redis_server_settings
  env      = var.env
  tags     = var.tags
  project  = var.teamname

  resource_group_name     = local.resource_group_name
  resource_group_name_hub = var.resource_group_name_hub
  virtual_network_name    = var.virtual_network_name

  name              = "redis-${each.key}"
  linktype          = "redis"
  resource_id       = azurerm_redis_cache.default[each.key].id
  subresource_names = ["RedisCache"]
  subnet_id = var.privatelink_subnet_id
}

resource "azurerm_role_assignment" "this" {
  depends_on = [azurerm_redis_cache.default]

  for_each             = var.redis_server_settings
  principal_id         = var.ad_group_id
  scope                = azurerm_redis_cache.default[each.key].id
  role_definition_name = "Contributor"
}