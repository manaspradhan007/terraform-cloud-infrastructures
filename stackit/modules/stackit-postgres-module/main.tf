module "postgres" {
  source           = "../../resources/postgres"
  postgres_name    = var.postgres_name
  acl_list         = var.acl_list
  cron             = var.cron
  cpu              = var.cpu
  ram              = var.ram
  replicas         = var.replicas
  class            = var.class
  size             = var.size
  postgres_version = var.postgres_version
  project_id       = var.project_id
  db_name          = var.db_name
  owner            = var.owner
}