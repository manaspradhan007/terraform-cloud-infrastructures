terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [azurerm.hub]
    }
  }
}

locals {
  cosmos_account_name = var.cosmos_account_name != "" ? var.cosmos_account_name : format("cosmos-%s-%s-%s", var.project, var.environment_short, var.prefix)
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rg.*.name, azurerm_resource_group.this.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rg.*.location, azurerm_resource_group.this.*.location, [""]), 0)
  firewall_ips        = var.firewall_ip == [] ? "${join(",", var.azure_portal_access)}" : "${join(",", var.firewall_ip, var.azure_portal_access)}"
}

data "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "this" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = var.tags
}

resource "azurerm_cosmosdb_account" "this" {
  name                          = local.cosmos_account_name
  location                      = local.location
  resource_group_name           = local.resource_group_name
  offer_type                    = var.offer_type
  kind                          = var.cosmos_api == "mongo" ? "MongoDB" : "GlobalDocumentDB"
  mongo_server_version          = var.cosmos_api == "mongo" ? var.mongo_server_version : null
  public_network_access_enabled = var.public_network_access_enabled
  ip_range_filter               = local.firewall_ips

  enable_automatic_failover          = var.auto_failover
  enable_free_tier                   = var.free_tier
  enable_multiple_write_locations    = var.multi_region_write
  is_virtual_network_filter_enabled  = var.is_virtual_network_filter_enabled
  local_authentication_disabled      = var.local_authentication_disabled
  access_key_metadata_writes_enabled = var.access_key_metadata_writes_enabled

  tags = var.tags

  consistency_policy {
    consistency_level = var.consistency_level
  }

  dynamic "capabilities" {
    for_each = var.cosmos_api == "sql" ? [] : [1]
    content {
      name = var.capabilities[var.cosmos_api]
    }
  }

  dynamic "capabilities" {
    for_each = var.additional_capabilities != null ? var.additional_capabilities : []
    content {
      name = capabilities.value
    }
  }

  dynamic "geo_location" {
    for_each = var.geo_locations
    content {
      location          = geo_location.value["geo_location"]
      failover_priority = geo_location.value["failover_priority"]
      zone_redundant    = geo_location.value["zone_redundant"]
    }
  }

  dynamic "backup" {
    for_each = var.backup_enabled == true ? [1] : []
    content {
      type                = title(var.backup_type)
      interval_in_minutes = lower(var.backup_type) == "periodic" ? var.backup_interval : ""
      retention_in_hours  = lower(var.backup_type) == "periodic" ? var.backup_retention : ""
    }
  }

  dynamic "identity" {
    for_each = var.enable_systemassigned_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  lifecycle {
    ignore_changes = [
      default_identity_type
    ]
  }
}

module "privatelink" {
  providers = {
    azurerm.hub = azurerm.hub
  }
  depends_on = [azurerm_cosmosdb_account.this]
  source = "../privatelink"

  location = local.location
  env      = var.environment_short
  tags     = var.tags
  project  = var.project

  resource_group_name     = local.resource_group_name
  resource_group_name_hub = var.resource_group_name_hub
  virtual_network_name    = var.virtual_network_name

  name              = format("cosmosdb-privatelink-%s", var.prefix)
  linktype          = "Cosmos-mongo"
  resource_id       = azurerm_cosmosdb_account.this.id
  subresource_names = [var.cosmos_api == "mongo" ? "MongoDB" : "GlobalDocumentDB"]
  subnet_id         = var.privatelink_subnet_id
}

resource "azurerm_role_assignment" "this" {
  principal_id         = var.ad_group_id
  scope                = azurerm_cosmosdb_account.this.id
  role_definition_name = "Contributor"
}

module "availability" {
  source = "../../grafana-resources/database-availability-alert"
  database = {
    name           = azurerm_cosmosdb_account.this.name
    resource_group = azurerm_cosmosdb_account.this.resource_group_name
    type           = "cosmosdb"
  }
  environment_long = var.environment_long
  location         = var.location
  subscription_id  = var.subscription_id
  alert_rule = {
    is_paused = var.database_availability_rule_is_paused
  }
}
