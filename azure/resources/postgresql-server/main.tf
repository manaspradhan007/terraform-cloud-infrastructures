module "postgresql" {
  source = "data-platform-hq/postgresql-flexible-server/azurerm"

  resource_group = var.resource_group.name
  location       = var.location

  project                = var.server_name
  env                    = var.env
  suffix                 = "0"
  sku_name               = var.server_sku
  storage_mb             = var.server_size
  administrator_login    = var.administrator_login
  administrator_password = random_password.postgresql_admin.result
  psql_version           = var.server_version
  databases              = var.db_names
  subnet_id              = var.subnet
  zone_id                = data.azurerm_private_dns_zone.private_dns_zone.id
  tags                   = var.tags
}

resource "azurerm_postgresql_flexible_server_configuration" "postgresql" {
  name      = "backslash_quote"
  server_id = module.postgresql.id
  value     = "on"

  depends_on = [module.postgresql]
}
