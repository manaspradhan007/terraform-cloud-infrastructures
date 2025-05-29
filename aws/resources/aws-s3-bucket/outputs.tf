output "s3_bucket_id" {
  description = "The ID of the S3 Bucket."
  value = var.enable_replication ? (var.add_lifecycle_policy ? (var.storage_class!="null" ? join("", aws_s3_bucket.with_lifecycle_with_replication.*.id) : join("", aws_s3_bucket.with_lifecycle_no_transition_with_replication.*.id) ) : join("", aws_s3_bucket.no_lifecycle_with_replication.*.id)) : (var.add_lifecycle_policy ? (var.storage_class!="null" ? join("", aws_s3_bucket.with_lifecycle.*.id) : join("", aws_s3_bucket.with_lifecycle_no_transition.*.id) ) : join("", aws_s3_bucket.no_lifecycle.*.id))
}


output "s3_bucket_name" {
  description = "The Name of the S3 Bucket."
  value = var.enable_replication ? (var.add_lifecycle_policy ? (var.storage_class!="null" ? join("", aws_s3_bucket.with_lifecycle_with_replication.*.id) : join("", aws_s3_bucket.with_lifecycle_no_transition_with_replication.*.id) ) : join("", aws_s3_bucket.no_lifecycle_with_replication.*.id)) : (var.add_lifecycle_policy ? (var.storage_class!="null" ? join("", aws_s3_bucket.with_lifecycle.*.id) : join("", aws_s3_bucket.with_lifecycle_no_transition.*.id) ) : join("", aws_s3_bucket.no_lifecycle.*.id))
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 Bucket."
  value = var.enable_replication ? (var.add_lifecycle_policy ? (var.storage_class!="null" ? join("", aws_s3_bucket.with_lifecycle_with_replication.*.arn) : join("", aws_s3_bucket.with_lifecycle_no_transition_with_replication.*.arn) ) : join("", aws_s3_bucket.no_lifecycle_with_replication.*.arn)) : (var.add_lifecycle_policy ? (var.storage_class!="null" ? join("", aws_s3_bucket.with_lifecycle.*.arn) : join("", aws_s3_bucket.with_lifecycle_no_transition.*.arn) ) : join("", aws_s3_bucket.no_lifecycle.*.arn))
}

output "s3_bucket_domain_name" {
  description = "The Domain Name of the S3 Bucket."
  value = var.enable_replication ? (var.add_lifecycle_policy ? (var.storage_class!="null" ? join("", aws_s3_bucket.with_lifecycle_with_replication.*.bucket_domain_name) : join("", aws_s3_bucket.with_lifecycle_no_transition_with_replication.*.bucket_domain_name) ) : join("", aws_s3_bucket.no_lifecycle_with_replication.*.bucket_domain_name)) : (var.add_lifecycle_policy ? (var.storage_class!="null" ? join("", aws_s3_bucket.with_lifecycle.*.bucket_domain_name) : join("", aws_s3_bucket.with_lifecycle_no_transition.*.bucket_domain_name) ) : join("", aws_s3_bucket.no_lifecycle.*.bucket_domain_name))
}

output "s3_bucket_transition_days" {
  description = "The Domain Name of the S3 Bucket."
  value = var.add_lifecycle_policy && var.storage_class!="null" ? var.transition_days : ""
}

output "s3_bucket_storage_class" {
  description = "The Domain Name of the S3 Bucket."
  value = var.add_lifecycle_policy && var.storage_class!="null" ? var.storage_class : ""
}

output "s3_bucket_expiration_days" {
  description = "The Domain Name of the S3 Bucket."
  value = var.add_lifecycle_policy && var.storage_class!="null" ? var.expiration_days : ""
}

output "s3_replication_bucket_id" {
  description = "The ID of the S3 Replication Bucket."
  value = var.enable_replication ? join("", aws_s3_bucket.replication_bucket.*.id) : ""
}

output "s3_replication_bucket_name" {
  description = "The Name of the S3 Replication Bucket."
  value = var.enable_replication ? join("", aws_s3_bucket.replication_bucket.*.id) : ""
}

output "s3_replication_bucket_arn" {
  description = "The ARN of the S3 Replication Bucket."
  value = var.enable_replication ? join("", aws_s3_bucket.replication_bucket.*.arn) : ""
}

output "s3_replication_bucket_domain_name" {
  description = "The Domain Name of the S3 Replication Bucket."
  value = var.enable_replication ? join("", aws_s3_bucket.replication_bucket.*.bucket_domain_name) : ""
}

output "s3_replication_bucket_expiration_days" {
  description = "The Domain Name of the S3 Bucket."
  value = var.enable_replication ? var.replication_expiration_days : ""
}


output "s3_replication_iam_role" {
  description = "The ARN of the IAM role for replication bucket"
  value = var.enable_replication ? join("", module.replication_bucket_iam_role.*.iam_role_arn) : ""
}
