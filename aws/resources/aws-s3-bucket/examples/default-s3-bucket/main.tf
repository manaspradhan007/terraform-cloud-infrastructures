module "default_s3_bucket_example" {
  source = "../../"



  bucket_name           = var.default_s3_bucket_example_bucket_name
  region                = var.region
  replication_region    = var.replication_region
  access_key            = var.access_key
  secret_key            = var.secret_key
  token                 = var.token
  enable_replication    = var.default_s3_bucket_example_enable_replication
  enable_versioning     = var.default_s3_bucket_example_enable_versioning
  force_destroy         = var.default_s3_bucket_example_force_destroy
  add_lifecycle_policy  = var.default_s3_bucket_example_add_lifecycle_policy
  expiration_days       = var.default_s3_bucket_example_expiration_days
  previous_version_expiration_days= var.default_s3_bucket_example_previous_version_expiration_days
  cleanup_incomplete_expiration_days= var.default_s3_bucket_example_cleanup_incomplete_expiration_days
  storage_class         = var.default_s3_bucket_example_storage_class
  transition_days       = var.default_s3_bucket_example_transition_days
  lifecycle_policy_name = var.default_s3_bucket_example_lifecycle_policy_name
  tags                  = var.default_s3_bucket_example_tags
  sse_algorithm          = var.default_s3_bucket_example_sse_algorithm
  kms_master_key_id      = var.default_s3_bucket_example_kms_master_key_id
  add_kms_encryption    = var.default_s3_bucket_example_add_kms_encryption
  add_noncurrent_version_transition  = var.default_add_noncurrent_version_transition
  noncurrent_version_transition_days = var.default_noncurrent_version_transition_days
  noncurrent_version_transition_storage_class = var.default_noncurrent_version_transition_storage_class
  add_logging       = var.default_add_logging
  log_target_bucket = var.default_log_target_bucket
  log_target_prefix = var.default_log_target_prefix
}

