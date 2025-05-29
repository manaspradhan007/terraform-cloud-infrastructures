variable "default_s3_bucket_example_bucket_name" {
}

variable "default_s3_bucket_example_enable_replication" {
}

variable "default_s3_bucket_example_enable_versioning" {
}

variable "default_s3_bucket_example_force_destroy" {
}

variable "default_s3_bucket_example_add_lifecycle_policy" {
}

variable "default_s3_bucket_example_expiration_days" {
}

variable "default_s3_bucket_example_previous_version_expiration_days" {
}

variable "default_s3_bucket_example_cleanup_incomplete_expiration_days" {
}

variable "default_s3_bucket_example_storage_class" {
}

variable "default_s3_bucket_example_transition_days" {
}

variable "default_s3_bucket_example_lifecycle_policy_name" {
}

variable "default_s3_bucket_example_tags" {
  type = map(string)
}

variable "default_s3_bucket_example_sse_algorithm" {
  description = "The server-side encryption algorithm to use. Valid values: 'AES256' or 'aws:kms'"
  default     = "AES256"
}

variable "default_s3_bucket_example_kms_master_key_id" {
  description = "kms_master_key_id"
  default     = "123"
}

variable "default_s3_bucket_example_add_kms_encryption" {
  description = "add_kms_encryption"
  default     = false
}

variable "default_add_noncurrent_version_transition" {
  description = "Set to true to add noncurrent_version_transition to the S3 bucket"
  default     = false
}

variable "default_noncurrent_version_transition_days" {
  description = "Specifies the number of days noncurrent object versions transition"
  type        = number
  default     = null
}

variable "default_noncurrent_version_transition_storage_class" {
  description = "Specifies the Amazon S3 storage class to which you want the noncurrent object versions to transition"
  default     = null
}

variable "default_add_logging" {
  description = "Set to true to add logging to the S3 bucket"
  default     = false
}

variable "default_log_target_bucket" {
  description = "The name of the bucket that will receive the log objects"
  default     = null
}

variable "default_log_target_prefix" {
  description = "To specify a key prefix for log objects"
  default     = null
}