resource "random_password" "pg_exporter" {
  length = 20
}

resource "azurerm_key_vault_secret" "postgresql_pg_exporter" {
  name         = "${var.server_name}-postgresql-pg-exporter"
  value        = random_password.pg_exporter.result
  key_vault_id = var.key_vault.id
}

resource "postgresql_role" "pg_exporter" {
  name             = "pg-exporter"
  login            = true
  connection_limit = 3
  password         = random_password.pg_exporter.result
  roles            = ["pg_monitor"]
}
