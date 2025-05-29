#############
# Providers #
#############

region     = "<insert region here>"
access_key = "<insert access_key here>"
secret_key = "<insert secret_key here>"
token      = "<insert token here>"

replication_region    = "us-east-2"

#############
# S3 Bucket #
#############
default_s3_bucket_example_bucket_name           = "d1r101-test-bucket-"
default_s3_bucket_example_enable_versioning     = true
default_s3_bucket_example_force_destroy         = true
default_s3_bucket_example_enable_replication    = false
#default_s3_bucket_example_sse_algorithm         = "aws:kms"
#default_s3_bucket_example_kms_master_key_id     = "arn:aws:kms:us-east-1:348141368423:key/0431ab15-f28d-4a6e-b62b-4da718ebd993"
#default_s3_bucket_example_add_kms_encryption    = true



######################
# Life Cycle Policy #
######################
default_s3_bucket_example_add_lifecycle_policy  = true
default_s3_bucket_example_expiration_days       = "180"
default_s3_bucket_example_previous_version_expiration_days = "2"
default_s3_bucket_example_cleanup_incomplete_expiration_days = "3"
default_s3_bucket_example_storage_class         = "GLACIER"
default_s3_bucket_example_transition_days       = "30"
default_s3_bucket_example_lifecycle_policy_name = "Move To Glacier"
#default_add_noncurrent_version_transition           = false
#default_noncurrent_version_transition_days          = 1
#default_noncurrent_version_transition_storage_class = "GLACIER"

###########
# Logging #
###########
#default_add_logging       = false
#default_log_target_bucket = ""
#default_log_target_prefix = ""

########
# Tags #
########
default_s3_bucket_example_tags                 = {"TenantCode" = "d1r101", "UserName" = "rashah", "0050:InfraMgmt" = ""}
