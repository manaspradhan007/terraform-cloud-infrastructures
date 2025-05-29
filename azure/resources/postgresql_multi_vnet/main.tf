data "azurerm_private_dns_zone" "postgresql_server_private_dns_zone" {
  name                = var.privatelink
  resource_group_name = var.resource_group_name_hub
}

resource "azurerm_subnet" "postgresql" {
  name                 = format("postgresql-subnet-%s-%s", var.project, var.environment_short)
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.postgresql_server_subnet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.Sql"]
  delegation {
    name = "Microsoft.DBforPostgreSQL.flexibleServers"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "random_password" "main" {
  count            = var.admin_password == null ? 1 : 0
  length           = 16
  min_upper        = 4
  min_lower        = 2
  min_numeric      = 4
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_postgresql_flexible_server" "postgresqlserver" {
  count                  = var.database_flexible ? 1 : 0
  location               = var.location
  name                   = "<name>-${var.project}-${var.environment_short}"
  delegated_subnet_id    = azurerm_subnet.postgresql.id
  private_dns_zone_id    = data.azurerm_private_dns_zone.postgresql_server_private_dns_zone.id
  resource_group_name    = var.resource_group_name
  version                = var.database_version
  administrator_login    = var.admin_username == null ? "postgresadmin" : var.admin_username
  administrator_password = var.admin_password == null ? random_password.main.0.result : var.admin_password
  sku_name               = var.database_host_sku
  storage_mb             = var.database_storage
  backup_retention_days  = var.backup_retention_days
  zone                   = var.availability_zone
  tags                   = var.tags

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  for_each  = var.database_flexible ? toset(var.database_suffixes) : []
  charset   = var.charset
  collation = var.collation
  name      = "${var.project}${var.environment_short}db${each.value}"
  server_id = azurerm_postgresql_flexible_server.postgresqlserver.0.id
}

module "availability" {
  source = "../../grafana-resources/database-availability-alert"
  database = {
    name           = azurerm_postgresql_flexible_server.postgresqlserver[0].name
    resource_group = azurerm_postgresql_flexible_server.postgresqlserver[0].resource_group_name
    type           = "postgresql"
  }
  environment_long = var.environment_long
  location         = var.location
  subscription_id  = var.subscription_id
  alert_rule = {
    is_paused = var.database_availability_rule_is_paused
  }
}

output "postgresqlserver_id" {
  value = azurerm_postgresql_flexible_server.postgresqlserver.0.id
}
