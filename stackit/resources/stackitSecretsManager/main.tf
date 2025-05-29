# provider "vault" {
#   address          = "https://prod.sm.eu01.stackit.cloud" 
#   alias          = "stackit"
#   skip_child_token = true
#   auth_login_userpass {
#     username = stackit_secretsmanager_user.sm_user.username
#     password = stackit_secretsmanager_user.sm_user.password
#   }
# }

resource "stackit_secretsmanager_instance" "secret_manager" {
  project_id = var.project_id
  name       = var.secretstore_name
}

resource "stackit_secretsmanager_user" "sm_user" {
  project_id    = var.project_id
  instance_id   = stackit_secretsmanager_instance.secret_manager.instance_id
  description   = "secret vault auth user"
  write_enabled = true
}

output "username" {
  value = stackit_secretsmanager_user.sm_user.username
}

output "password" {
  value = stackit_secretsmanager_user.sm_user.password
}

output "id" {
  value = stackit_secretsmanager_user.sm_user.id
}