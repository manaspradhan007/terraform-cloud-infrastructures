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
  location = var.location #element(coalescelist(data.azurerm_resource_group.parent_rg.*.location, [""]), 0)

  privlink_dns_map = {
    "cosmos-mongo" = "privatelink.mongo.cosmos.azure.com",
    "mysql"        = "privatelink.mysql.database.azure.com",
    "postgres"     = "privatelink.postgres.database.azure.come",
    "redis"        = "privatelink.redis.cache.windows.net",
    "blob"         = "privatelink.blob.core.windows.net",
    "vault"        = "privatelink.vaultcore.azure.net",
  }
  privatelink_dns_name = lookup(local.privlink_dns_map, lower(var.linktype))

  #private link-resouce https://learn.microsoft.com/de-de/azure/private-link/private-endpoint-overview#private-link-resource
  privlink_resource_map = {
    "cosmos-mongo" = ["MongoDB"],
    "mysql"        = ["mysqlServer"],
    "postgres"     = ["postgresqlServer"],
    "redis"        = ["RedisCache"],
    "blob"         = ["blob"]
    "vault"        = ["vault"]
  }
  subresource_names = setunion(lookup(local.privlink_resource_map, lower(var.linktype)), var.subresource_names)
}

#------------------------------------------------------------
# Data section
#------------------------------------------------------------
data "azurerm_private_dns_zone" "privatelink_dns_zone" {
  name                = local.privatelink_dns_name
  resource_group_name = var.resource_group_name_hub
}

# data "azurerm_subnet" "privatelink_subnet" {
#   name                 = var.privatelink_subnet_name
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = var.virtual_network_name
# }

#------------------------------------------------------------
# Resouces: private Endpoint
#------------------------------------------------------------

resource "azurerm_private_endpoint" "this" {
  name                = lower(format("%s-%s-%s", var.name, var.project, var.env))
  resource_group_name = var.resource_group_name
  location            = local.location
  tags                = var.tags
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.privatelink_dns_zone.id] #
  }

  private_service_connection {
    private_connection_resource_id = var.resource_id
    name                           = element(split("/", var.resource_id), 8)
    is_manual_connection           = false
    subresource_names              = local.subresource_names
  }

  lifecycle {
    create_before_destroy = false
  }
}
