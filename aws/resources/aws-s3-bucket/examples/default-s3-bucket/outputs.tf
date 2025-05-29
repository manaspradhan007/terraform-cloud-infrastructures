output "default_s3_bucket_example_s3_bucket_id" {
  description = "The ID of the S3 Bucket."
  value       = module.default_s3_bucket_example.s3_bucket_id
}

output "default_s3_bucket_example_s3_bucket_name" {
  description = "The Name of the S3 Bucket."
  value       = module.default_s3_bucket_example.s3_bucket_name
}

output "default_s3_bucket_example_s3_bucket_arn" {
  description = "The ARN of the S3 Bucket."
  value       = module.default_s3_bucket_example.s3_bucket_arn
}

output "default_s3_bucket_example_s3_bucket_domain_name" {
  description = "The Domain Name of the S3 Bucket."
  value       = module.default_s3_bucket_example.s3_bucket_domain_name
}

output "default_s3_bucket_example_s3_bucket_transition_days" {
  description = "The transition days of the S3 Bucket."
  value       = module.default_s3_bucket_example.s3_bucket_transition_days
}

output "default_s3_bucket_example_s3_bucket_storage_class" {
  description = "The storage class of the S3 Bucket."
  value       = module.default_s3_bucket_example.s3_bucket_storage_class
}

output "default_s3_bucket_example_s3_bucket_expiration_days" {
  description = "The expiration days of the S3 Bucket."
  value       = module.default_s3_bucket_example.s3_bucket_expiration_days
}

output "default_s3_bucket_example_s3_replication_bucket_id" {
  description = "The ID of the S3 Replication Bucket."
  value       = module.default_s3_bucket_example.s3_replication_bucket_id
}

output "default_s3_bucket_example_s3_replication_bucket_name" {
  description = "The Name of the S3 Replication Bucket."
  value       = module.default_s3_bucket_example.s3_replication_bucket_name
}

output "default_s3_bucket_example_s3_replication_bucket_arn" {
  description = "The ARN of the S3 Replication Bucket."
  value       = module.default_s3_bucket_example.s3_replication_bucket_arn
}

output "default_s3_bucket_example_s3_replication_bucket_domain_name" {
  description = "The Domain Name of the S3 Replication Bucket."
  value       = module.default_s3_bucket_example.s3_replication_bucket_domain_name
}

output "default_s3_bucket_example_s3_replication_bucket_expiration_days" {
  description = "The expiration days of the S3 Replication Bucket."
  value       = module.default_s3_bucket_example.s3_replication_bucket_expiration_days
}


output "default_s3_bucket_example_s3_replication_iam_role" {
  description = "The ARN of the IAM role for replication bucket"
  value =  module.default_s3_bucket_example.s3_replication_iam_role
}
