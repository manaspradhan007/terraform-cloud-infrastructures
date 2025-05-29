##########
# Common #
##########
variable "execute_microservice" {
  description = "Main switch to control the execution of this microservice based on consumer logic."
  default     = true
}

variable "bucket_name" {
  description = "Name prefix to be used to derive names for all the resources."
}

variable "region" {
  description = "region"
  default     = "us-east-1"
}

variable "replication_region" {
  description = "replication bucket region"
  default     = "us-east-2"
}

variable "access_key" {
}

variable "secret_key" {
}

variable "token" {
}

variable "enable_replication" {
  description = "Create a replication bucket and enable replication for created bucket."
  default     = false
}

######################
# Replication Bucket #
######################
variable "replication_principal_acc_id" {
  type        = list(string)
  description = "Replication bucket principal account id"
  default     = []
}

variable "replication_principal_arn" {
  type        = list(string)
  description = "Replication bucket principal arn"
  default     = ["s3.amazonaws.com"]
}

variable "replication_expiration_days" {
  description = "expiration days of replication bucket"
  default     = "8"
}


#############
# S3 Bucket #
#############
variable "acl" {
  description = "The canned ACL to apply. Valid values: private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, bucket-owner-full-control, log-delivery-write."
  default     = "private"
}

variable "force_destroy" {
  description = "Controls if all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
}

variable "bucket_policy_json" {
  description = "A valid bucket policy JSON document."
  default     = ""
}

variable "enable_versioning" {
  description = "Controls if the versioning should be enabled."
  default     = false
}

variable "sse_algorithm" {
  description = "The server-side encryption algorithm to use. Valid values: 'AES256' or 'aws:kms'"
  default     = "AES256"
}

variable "kms_master_key_id" {
  description = "kms_master_key_id"
  default     = "123"
}

variable "add_kms_encryption" {
  description = "add_kms_encryption"
  default     = false
}


#####################
# Life Cycle Policy #
#####################
variable "add_lifecycle_policy" {
  description = "lifecycle policy"
  default     = false
}

variable "expiration_days" {
  description = "expiration days"
  default     = false
}

variable "previous_version_expiration_days" {
  description = "Permanently delete previous versions"
  default     = 1
}

variable "cleanup_incomplete_expiration_days" {
  description = "cleanup incomplete multipart uploads"
  default     = 2
}

variable "storage_class" {
  description = "storage class"
  default     = false
}

variable "transition_days" {
  description = "transition days"
  default     = false
}

variable "lifecycle_policy_name" {
  description = "lifecycle policy name"
  default     = false
}

variable "add_noncurrent_version_transition" {
  description = "Set to true to add noncurrent_version_transition to the S3 bucket"
  default     = false
}

variable "noncurrent_version_transition_days" {
  description = "Specifies the number of days noncurrent object versions transition"
  type        = number
  default     = null
}

variable "noncurrent_version_transition_storage_class" {
  description = "Specifies the Amazon S3 storage class to which you want the noncurrent object versions to transition"
  default     = null
}

###########
# Logging #
###########

variable "add_logging" {
  description = "Set to true to add logging to the S3 bucket"
  default     = false
}

variable "log_target_bucket" {
  description = "The name of the bucket that will receive the log objects"
  default     = null
}

variable "log_target_prefix" {
  description = "To specify a key prefix for log objects"
  default     = null
}

########
# Tags #
########
variable "tags" {
  description = "A map of tags to be added to all resources."
  default     = {}
}

