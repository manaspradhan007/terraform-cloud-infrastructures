locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.default.*.name, azurerm_resource_group.default.*.name, [""]), 0)
  location            = var.location
}

################################################################################
# data
################################################################################

data "azurerm_private_dns_zone" "blob_storage_private_dns_zone" {
  name                = var.privatelinkblob
  resource_group_name = var.resource_group_name_hub
}

data "azurerm_private_dns_zone" "file_storage_private_dns_zone" {
  # provider            = azurerm.hub
  name                = var.privatelinkfile
  resource_group_name = var.resource_group_name_hub
}

data "azurerm_resource_group" "default" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "default" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = local.location
  tags     = var.tags
}

resource "azurerm_subnet" "default" {
  name                                      = format("%s-%s-storagesubnet-%s", var.teamname, var.env, var.num) ###
  resource_group_name                       = var.vnet_resource_group                                          # vnet can be in any resource group and should not be part of same resource group of storage acc.
  virtual_network_name                      = var.vnet_name
  address_prefixes                          = var.storageaccount_subnet_address
  service_endpoints                         = ["Microsoft.Sql", "Microsoft.Storage"]
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_storage_account" "default" {
  name                      = substr(format("%s%s%s", lower(replace(var.storage_account_name, "/[[:^alnum:]]/", "")), var.env, var.num), 0, 24, ) ####
  resource_group_name       = local.resource_group_name
  location                  = local.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = true
  shared_access_key_enabled = true
  #large_file_share_enabled  = true # will only work with locally redundant and zone redundantwhen we need 100Tib
  #retention_policy_days     = var.retention_policy_days
  # enable_large_file_share   = var.enable_large_file_share
  min_tls_version = var.min_tls_version
  # container_delete_retention_policy = var.container_soft_delete_retention_days
  # delete_retention_policy           = var.blob_soft_delete_retention_days
  tags = var.tags
  dynamic "static_website" {
    for_each = var.static_website
    content {
      index_document     = static_website.value["index_document"]
      error_404_document = static_website.value["error_404_document"]
    }
  }
  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_storage_account_network_rules" "default" {
  storage_account_id = azurerm_storage_account.default.id
  default_action     = var.azurerm_storage_account_network_rule_default_action
  bypass             = var.azurerm_storage_account_network_rules_bypass
  ip_rules           = var.azurerm_storage_account_network_rules_ip_rules
}

resource "azurerm_private_endpoint" "default" {
  depends_on          = [azurerm_storage_account.default]
  name                = format("<name>-%s-%s", var.teamname, var.env)
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = var.tags
  subnet_id           = azurerm_subnet.default.id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_id
  }

  private_service_connection {
    private_connection_resource_id = azurerm_storage_account.default.id
    name                           = format("%s-%s", var.teamname, "psc")
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

################################################################################
# storage container
################################################################################
resource "azurerm_storage_container" "default" {
  count                 = length(var.containers_list)
  name                  = var.containers_list[count.index].name
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = var.containers_list[count.index].access_type
}

################################################################################
# storage container fileshare
################################################################################
resource "azurerm_storage_share" "default" {
  count                = length(var.file_shares)
  name                 = var.file_shares[count.index].name
  storage_account_name = azurerm_storage_account.default.name
  quota                = var.file_shares[count.index].quota
}