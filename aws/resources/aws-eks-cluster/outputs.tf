output "cluster_security_group_id" {
  description = "ID of the EKS cluster Security Group"
  value       = join("", aws_security_group.cluster_default.*.id)
}

output "cluster_security_group_arn" {
  description = "ARN of the EKS cluster Security Group"
  value       = join("", aws_security_group.cluster_default.*.arn)
}

output "cluster_security_group_name" {
  description = "Name of the EKS cluster Security Group"
  value       = join("", aws_security_group.cluster_default.*.name)
}

output "cluster_id" {
  description = "The name of the cluster"
  value       = join("", aws_eks_cluster.this.*.id)
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = join("", aws_eks_cluster.this.*.arn)
}

output "cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = join("", aws_eks_cluster.this.*.endpoint)
}

output "cluster_kubernetes_version" {
  description = "The Kubernetes server version of the cluster"
  value       = join("", aws_eks_cluster.this.*.version)
}

output "cluster_managed_security_group_id" {
  description = "Security Group ID that was created by EKS for the cluster. EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads"
  value       = join("", aws_eks_cluster.this.*.vpc_config.0.cluster_security_group_id)
}

output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = join("", aws_iam_role.cluster_role.*.arn)
}

output "cluster_encryption_config_resources" {
  description = "Cluster Encryption Config Resources"
  value       = var.cluster_encryption_config_resources
}

output "cluster_encryption_config_provider_key_arn" {
  description = "Cluster Encryption Config KMS Key ARN"
  value       = var.kms_key_arn_for_cluster_encryption
}


output "cluster_add_on_details" {
  description = "EKS addon details"
   value =  [
    for add_on in aws_eks_addon.this :
      map("add_on_id", add_on.id, "add_on_arn", add_on.arn, "add_on_created_at",add_on.created_at, "cluster_add_on_modified_at",add_on.modified_at)
  ]
}