data "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group.name
}
