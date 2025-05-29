module "default_eks_example" {
  source = "../../"

execute_microservice = var.execute_microservice
resource_name_prefix = var.default_eks_example_resource_name_prefix
tags = var.default_eks_example_tags
subnet_ids = var.default_eks_example_subnet_ids
enable_cluster_endpoint_public_access = var.default_eks_example_enable_cluster_endpoint_public_access
enable_cluster_endpoint_private_access =  var.default_eks_example_enable_cluster_endpoint_private_access
cluster_public_access_cidrs = var.default_eks_example_cluster_public_access_cidrs
kms_key_arn_for_cluster_encryption = var.default_eks_example_kms_key_arn_for_cluster_encryption
cluster_encryption_config_resources = var.default_eks_example_cluster_encryption_config_resources
enabled_cluster_log_types = var.default_eks_example_enabled_cluster_log_types
eks_cluster_addons = var.default_eks_example_eks_cluster_addons
cluster_default_sg_ingress_rules = var.default_eks_example_cluster_default_sg_ingress_rules
}

