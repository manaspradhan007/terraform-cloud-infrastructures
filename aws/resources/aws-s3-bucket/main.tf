data "aws_caller_identity" "current" {
}

locals {
  replication_bucket_iam_custom_policy_json = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}"
        ]
      },
      {
        "Action": [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
      {
        "Action": [
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${var.bucket_name}-repl/*"
      }
    ]
}
EOF
}

###########################
# Replication Bucket Role #
###########################

module "replication_bucket_iam_role" {
  source   = "git::ssh://<your-git-repo-url-here>/lmd/terraform-aws-iam-role.git?ref=v2.0.2"

  execute_microservice      = var.execute_microservice && var.enable_replication
  resource_name_prefix     = "${lower(var.bucket_name)}-cross_region_repl"
  principals_arns          = var.replication_principal_acc_id
  principals_services_arns = var.replication_principal_arn
  iam_role_description     = "${lower(var.bucket_name)}-cross_region_repl"
  custom_policy_json       = local.replication_bucket_iam_custom_policy_json
  create_instance_profile  = var.enable_replication
  tags = merge(
    {
      "Name" = "${var.bucket_name}-repl"
    },
    var.tags
  )
}

#########################
# Default Bucket Policy #
#########################
data "aws_iam_policy_document" "this" {
  count = var.execute_microservice && var.bucket_policy_json == "" ? 1 : 0

  statement {
    sid     = "AllowPublicRead"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
                "arn:aws:s3:::${lower(var.bucket_name)}",
                "arn:aws:s3:::${lower(var.bucket_name)}/*"
            ]
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
  }
}

#####################################
# Default Replication Bucket Policy #
#####################################
data "aws_iam_policy_document" "this_replication" {
  count = (var.execute_microservice && var.enable_replication) ? 1 : 0

  statement {
    sid     = "AllowPublicRead"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
                "arn:aws:s3:::${lower(var.bucket_name)}-repl",
                "arn:aws:s3:::${lower(var.bucket_name)}-repl/*"
            ]
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
  }
}

######################
# Replication Bucket #
######################

resource "aws_s3_bucket" "replication_bucket" {
  count = (var.execute_microservice && var.enable_replication) ? 1 : 0

  provider = aws.replication

  bucket        = "${lower(var.bucket_name)}-repl"
  acl           = var.acl
  force_destroy = var.force_destroy
  policy        = data.aws_iam_policy_document.this_replication[0].json

  versioning {
    enabled = var.enable_versioning
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [1] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
          kms_master_key_id = var.kms_master_key_id
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [] : [1]

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
        }
      }
    }
  }


  lifecycle_rule {
    id      = var.lifecycle_policy_name
    enabled = true 
    expiration {
      days = var.replication_expiration_days
    }

    noncurrent_version_expiration {
      days = var.previous_version_expiration_days
    }
    abort_incomplete_multipart_upload_days = var.cleanup_incomplete_expiration_days

  }

  tags = merge(
    {
      "Name" = lower(var.bucket_name)
    },
    var.tags,
  )
}

locals {
  bucket_with_licefycle = (var.execute_microservice && var.add_lifecycle_policy) && var.storage_class !="null"
  bucket_with_lifecycle_no_transition = (var.execute_microservice && var.add_lifecycle_policy) && var.storage_class =="null"
  bucket_no_lifecycle = var.execute_microservice && false == var.add_lifecycle_policy
}

###############################################
# S3 Bucket with Encyption and Lifecycle Rule  #
###############################################
resource "aws_s3_bucket" "with_lifecycle" {
  count = local.bucket_with_licefycle && !var.enable_replication ? 1 : 0

  bucket        = lower(var.bucket_name)
  acl           = var.acl
  force_destroy = var.force_destroy
  policy        = var.bucket_policy_json != "" ? var.bucket_policy_json : data.aws_iam_policy_document.this[0].json

  versioning {
    enabled = var.enable_versioning
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [1] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
          kms_master_key_id = var.kms_master_key_id
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [] : [1]

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
        }
      }
    }
  }

  lifecycle_rule {
    id      = var.lifecycle_policy_name
    enabled = true 
    transition {
      days          = var.transition_days
      storage_class = var.storage_class
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.add_noncurrent_version_transition ? [1] : []
      content {
        days          = var.noncurrent_version_transition_days
        storage_class = var.noncurrent_version_transition_storage_class
      }
    }

    expiration {
      days = var.expiration_days
    }

    noncurrent_version_expiration {
      days = var.previous_version_expiration_days
    }
    abort_incomplete_multipart_upload_days = var.cleanup_incomplete_expiration_days

  }

  dynamic "logging" {
    for_each = var.add_logging ? [1] : []
    content {
      target_bucket = var.log_target_bucket
      target_prefix = var.log_target_prefix
    }
  }

  tags = merge(
    {
      "Name" = lower(var.bucket_name)
    },
    var.tags,
  )
}

################################################################
# S3 Bucket with Encyption and Lifecycle Rule and No Transition#
################################################################
resource "aws_s3_bucket" "with_lifecycle_no_transition" {
  count = local.bucket_with_lifecycle_no_transition && !var.enable_replication ? 1 : 0

  bucket        = lower(var.bucket_name)
  acl           = var.acl
  force_destroy = var.force_destroy
  policy        = var.bucket_policy_json != "" ? var.bucket_policy_json : data.aws_iam_policy_document.this[0].json

  versioning {
    enabled = var.enable_versioning
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [1] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
          kms_master_key_id = var.kms_master_key_id
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [] : [1]

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
        }
      }
    }
  }


  lifecycle_rule {
    id      = var.lifecycle_policy_name
    enabled = true 
    expiration {
      days = var.expiration_days
    }

    noncurrent_version_expiration {
      days = var.previous_version_expiration_days
    }
    abort_incomplete_multipart_upload_days = var.cleanup_incomplete_expiration_days

  }

  dynamic "logging" {
    for_each = var.add_logging ? [1] : []
    content {
      target_bucket = var.log_target_bucket
      target_prefix = var.log_target_prefix
    }
  }

  tags = merge(
    {
      "Name" = lower(var.bucket_name)
    },
    var.tags,
  )
}

##############################################
# S3 Bucket with Encyption no Lifecycle Rule #
##############################################
resource "aws_s3_bucket" "no_lifecycle" {
  count = local.bucket_no_lifecycle && !var.enable_replication ? 1 : 0

  bucket        = lower(var.bucket_name)
  acl           = var.acl
  force_destroy = var.force_destroy
  policy        = var.bucket_policy_json != "" ? var.bucket_policy_json : data.aws_iam_policy_document.this[0].json
  versioning {
    enabled = var.enable_versioning
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [1] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
          kms_master_key_id = var.kms_master_key_id
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [] : [1]

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.add_logging ? [1] : []
    content {
      target_bucket = var.log_target_bucket
      target_prefix = var.log_target_prefix
    }
  }

  tags = merge(
    {
      "Name" = lower(var.bucket_name)
    },
    var.tags,
  )
}

#################################################################
# S3 Bucket with Encyption and Lifecycle Rule with Replication  #
#################################################################
resource "aws_s3_bucket" "with_lifecycle_with_replication" {
  count = local.bucket_with_licefycle && var.enable_replication ? 1 : 0

  depends_on = [
    aws_s3_bucket.replication_bucket[0],
  ]

  bucket        = lower(var.bucket_name)
  acl           = var.acl
  force_destroy = var.force_destroy
  policy        = var.bucket_policy_json != "" ? var.bucket_policy_json : data.aws_iam_policy_document.this[0].json

  versioning {
    enabled = var.enable_versioning
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [1] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
          kms_master_key_id = var.kms_master_key_id
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [] : [1]

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
        }
      }
    }
  }

  lifecycle_rule {
    id      = var.lifecycle_policy_name
    enabled = true 
    transition {
      days          = var.transition_days
      storage_class = var.storage_class
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.add_noncurrent_version_transition ? [1] : []
      content {
        days          = var.noncurrent_version_transition_days
        storage_class = var.noncurrent_version_transition_storage_class
      }
    }

    expiration {
      days = var.expiration_days
    }

    noncurrent_version_expiration {
      days = var.previous_version_expiration_days
    }
    abort_incomplete_multipart_upload_days = var.cleanup_incomplete_expiration_days

  }

  replication_configuration {
    role = module.replication_bucket_iam_role.iam_role_arn
    rules {
      id     = "all"
      status = "Enabled"

      destination {
        bucket = aws_s3_bucket.replication_bucket[0].arn
      }
    }
  }

  dynamic "logging" {
    for_each = var.add_logging ? [1] : []
    content {
      target_bucket = var.log_target_bucket
      target_prefix = var.log_target_prefix
    }
  }

  tags = merge(
    {
      "Name" = lower(var.bucket_name)
    },
    var.tags,
  )
}

###################################################################################
# S3 Bucket with Encyption and Lifecycle Rule and No Transition  with Replication #
###################################################################################
resource "aws_s3_bucket" "with_lifecycle_no_transition_with_replication" {
  count = local.bucket_with_lifecycle_no_transition && var.enable_replication ? 1 : 0
  
  depends_on = [
    aws_s3_bucket.replication_bucket[0],
  ]

  bucket        = lower(var.bucket_name)
  acl           = var.acl
  force_destroy = var.force_destroy
  policy        = var.bucket_policy_json != "" ? var.bucket_policy_json : data.aws_iam_policy_document.this[0].json

  versioning {
    enabled = var.enable_versioning
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [1] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
          kms_master_key_id = var.kms_master_key_id
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [] : [1]

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
        }
      }
    }
  }


  lifecycle_rule {
    id      = var.lifecycle_policy_name
    enabled = true 
    expiration {
      days = var.expiration_days
    }

    noncurrent_version_expiration {
      days = var.previous_version_expiration_days
    }
    abort_incomplete_multipart_upload_days = var.cleanup_incomplete_expiration_days

  }

  replication_configuration {
    role = module.replication_bucket_iam_role.iam_role_arn
    rules {
      id     = "all"
      status = "Enabled"

      destination {
        bucket = aws_s3_bucket.replication_bucket[0].arn
      }
    }
  }

  dynamic "logging" {
    for_each = var.add_logging ? [1] : []
    content {
      target_bucket = var.log_target_bucket
      target_prefix = var.log_target_prefix
    }
  }

  tags = merge(
    {
      "Name" = lower(var.bucket_name)
    },
    var.tags,
  )
}

###############################################################
# S3 Bucket with Encyption no Lifecycle Rule with Replication #
###############################################################
resource "aws_s3_bucket" "no_lifecycle_with_replication" {
  count = local.bucket_no_lifecycle && var.enable_replication ? 1 : 0
  
  depends_on = [
    aws_s3_bucket.replication_bucket[0],
  ]

  bucket        = lower(var.bucket_name)
  acl           = var.acl
  force_destroy = var.force_destroy
  policy        = var.bucket_policy_json != "" ? var.bucket_policy_json : data.aws_iam_policy_document.this[0].json
  versioning {
    enabled = var.enable_versioning
  }
  
  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [1] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
          kms_master_key_id = var.kms_master_key_id
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.add_kms_encryption ? [] : [1]

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
        }
      }
    }
  }

  replication_configuration {
    role = module.replication_bucket_iam_role.iam_role_arn
    rules {
      id     = "all"
      status = "Enabled"

      destination {
        bucket = aws_s3_bucket.replication_bucket[0].arn
      }
    }
  }

  dynamic "logging" {
    for_each = var.add_logging ? [1] : []
    content {
      target_bucket = var.log_target_bucket
      target_prefix = var.log_target_prefix
    }
  }

  tags = merge(
    {
      "Name" = lower(var.bucket_name)
    },
    var.tags,
  )
}

