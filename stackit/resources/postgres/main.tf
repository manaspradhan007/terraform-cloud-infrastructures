
resource "stackit_postgresflex_instance" "postgres" {
  project_id      = var.project_id
  name            = var.postgres_name
  acl             = var.acl_list
  backup_schedule = var.cron
  flavor = {
    cpu = var.cpu
    ram = var.ram
  }
  replicas = var.replicas
  storage = {
    class = var.class
    size  = var.size
  }
  version = var.postgres_version
}

resource "stackit_postgresflex_database" "example" {
  project_id  = var.project_id
  for_each    = toset(var.db_name)
  instance_id = stackit_postgresflex_instance.postgres.instance_id
  name        = each.value
  owner       = var.owner
}