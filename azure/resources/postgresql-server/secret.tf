resource "random_password" "postgresql_admin" {
  length = 20
}

resource "azurerm_key_vault_secret" "postgresql_admin" {
  name         = "${var.server_name}-postgresql-admin"
  value        = random_password.postgresql_admin.result
  key_vault_id = var.key_vault.id
}
