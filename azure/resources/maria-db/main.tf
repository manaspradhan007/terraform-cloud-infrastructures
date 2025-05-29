resource "azurerm_resource_group" "mariaDB_server" {
  name     = "mariadb-db-RG-${var.environment}"
  location = var.region
}

resource "random_password" "maria_db_admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_mariadb_server" "mariaDB_server" {
  name                = "mariadb-svr-${var.environment}-${var.teamname}"
  location            = azurerm_resource_group.maira_db_rg.location
  resource_group_name = azurerm_resource_group.maira_db_rg.name

  sku_name = var.sku_name

  storage_mb                   = var.server_db_storage_md
  backup_retention_days        = var.server_geo_redundant_backup_enabled
  geo_redundant_backup_enabled = var.server_geo_redundant_backup_enabled

  administrator_login          = var.server_administrator_login_password
  administrator_login_password = random_password.maria_db_admin_password
  version                      = var.server_version
  ssl_enforcement_enabled      = var.server_ssl_enforcement_enabled
}

resource "azurerm_mariadb_database" "mariaDB_database" {
  name                = "${var.database_name}-${var.environment}-${var.teamname}"
  resource_group_name = azurerm_resource_group.mariaDB_server.name
  server_name         = azurerm_mariadb_server.mariaDB_server.name
  charset             = var.database_charset
  collation           = var.database_collation
}