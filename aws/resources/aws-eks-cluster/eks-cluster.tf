data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

resource "aws_security_group" "cluster_default" {
  count = var.execute_microservice ? 1 : 0

  name = format("%s-%s", var.resource_name_prefix, "CLUSTER-SG")
  vpc_id = data.aws_subnet.selected.vpc_id
  dynamic "ingress" {
    for_each = var.cluster_default_sg_ingress_rules
    content {

      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      description      = lookup(ingress.value, "description", null)
      from_port        = lookup(ingress.value, "from_port", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", null)
      protocol         = lookup(ingress.value, "protocol", null)
      security_groups  = lookup(ingress.value, "security_groups", null)
      self             = lookup(ingress.value, "self", null)
      to_port          = lookup(ingress.value, "to_port", null)
    }
  }
  dynamic "egress" {
    for_each = var.cluster_default_sg_egress_rules
    content {

      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      description      = lookup(egress.value, "description", null)
      from_port        = lookup(egress.value, "from_port", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      protocol         = lookup(egress.value, "protocol", null)
      security_groups  = lookup(egress.value, "security_groups", null)
      self             = lookup(egress.value, "self", null)
      to_port          = lookup(egress.value, "to_port", null)
    }
  }
  tags = merge(
    {
      "Name" = format("%s-%s", var.resource_name_prefix, "CLUSTER-SG")
    },
    var.tags
  )
}


resource "aws_cloudwatch_log_group" "this" {
  count             = var.execute_microservice && length(var.enabled_cluster_log_types) > 0 ? 1 : 0
  name              = "/aws/eks/${var.resource_name_prefix}/cluster"
  retention_in_days = var.cluster_log_retention_period
    tags = merge(
    {
      "Name" = format("%s-%s", var.resource_name_prefix, "LOG-GROUP")
    },
    var.tags,
  )
}

resource "aws_eks_cluster" "this" {
# Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
# Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_clusterpolicy_attachment,
    aws_cloudwatch_log_group.this
  ]
  
  count = var.execute_microservice ? 1 :0

  name     = format("%s-%s", var.resource_name_prefix, "CLUSTER")
  role_arn = aws_iam_role.cluster_role[0].arn
  enabled_cluster_log_types = var.enabled_cluster_log_types
  version = var.kubernetes_version

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_private_access = var.enable_cluster_endpoint_private_access
    endpoint_public_access = var.enable_cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_public_access_cidrs
    security_group_ids = sort(concat(aws_security_group.cluster_default.*.id, var.cluster_security_groups))
  }

  dynamic "encryption_config" {
    for_each = var.kms_key_arn_for_cluster_encryption == "" ? [] : [1]
    content {
      resources = var.cluster_encryption_config_resources
      provider {
        key_arn = var.kms_key_arn_for_cluster_encryption
      }
    }
  }
  tags = merge(
    {
      "Name" = format("%s-%s", var.resource_name_prefix, "CLUSTER")
    },
    var.tags,
  )
  
}

resource "aws_eks_addon" "this" {
 count = var.execute_microservice && length(var.eks_cluster_addons) > 0 ? length(var.eks_cluster_addons) : 0
  cluster_name = aws_eks_cluster.this[0].name
  addon_name   = lookup(var.eks_cluster_addons[count.index],"name")
  addon_version = lookup(var.eks_cluster_addons[count.index],"version",null)
  resolve_conflicts = lookup(var.eks_cluster_addons[count.index],"resolve_conflicts","NONE")
}