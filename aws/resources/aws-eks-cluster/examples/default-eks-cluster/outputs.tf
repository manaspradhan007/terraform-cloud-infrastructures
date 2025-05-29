output "default_eks_example_cluster_security_group_id" {
  description = "ID of the EKS cluster Security Group"
  value       = module.default_eks_example.cluster_security_group_id
}

output "default_eks_example_cluster_security_group_arn" {
  description = "ARN of the EKS cluster Security Group"
  value       = module.default_eks_example.cluster_security_group_arn
}

output "cluster_security_group_name" {
  description = "Name of the EKS cluster Security Group"
  value       = module.default_eks_example.cluster_security_group_name
}

output "default_eks_example_cluster_id" {
  description = "The name of the cluster"
  value       = module.default_eks_example.cluster_id
}

output "default_eks_example_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.default_eks_example.cluster_arn
}

output "default_eks_example_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = module.default_eks_example.cluster_endpoint
}

output "default_eks_example_cluster_kubernetes_version" {
  description = "The Kubernetes server version of the cluster"
  value       = module.default_eks_example.cluster_kubernetes_version
}

output "default_eks_example_cluster_managed_security_group_id" {
  description = "Security Group ID that was created by EKS for the cluster. EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads"
  value       = module.default_eks_example.cluster_managed_security_group_id
}

output "default_eks_example_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = module.default_eks_example.cluster_role_arn
}

output "default_eks_example_cluster_encryption_config_resources" {
  description = "Cluster Encryption Config Resources"
  value       = module.default_eks_example.cluster_encryption_config_resources
}

output "default_eks_example_cluster_encryption_config_provider_key_arn" {
  description = "Cluster Encryption Config KMS Key ARN"
  value       = module.default_eks_example.cluster_encryption_config_provider_key_arn
}

output "default_eks_example_cluster_add_on_details" {
  description = "EKS addon details"
   value = module.default_eks_example.cluster_add_on_details
}