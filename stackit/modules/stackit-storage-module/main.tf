# ##############################################
# # Deploy Stackit Object Storage
# ##############################################
module "storage" {
  source       = "../../resources/storage"
  project_id   = var.project_id
  storage_name = var.storage_name
  policy       = var.policy
}