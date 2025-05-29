
provider "postgresql" {
  host            = try(module.postgresql.fqdn, "")
  database        = try("postgres", "")
  username        = try(module.postgresql.administrator_login, "")
  password        = try(random_password.postgresql_admin.result, "")
  sslmode         = "require"
  connect_timeout = 15
  superuser       = false
}
