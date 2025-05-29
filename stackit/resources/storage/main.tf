# ##############################################
# # Deploy Stackit Object Storage
# ##############################################

resource "stackit_objectstorage_bucket" "storage" {
  project_id = var.project_id
  name       = var.storage_name
}

resource "aws_s3_bucket_policy" "restrict_access" {
  bucket = var.storage_name
  policy = var.policy
}