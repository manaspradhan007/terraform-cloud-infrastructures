output "default_linux_server_example_instance_id" {
  description = "The Instance ID."
  value       = module.default_linux_server_example.instance_id
}

output "default_linux_server_example_key_name" {
  description = "The key name of the instance."
  value       = module.default_linux_server_example.key_name
}

output "default_linux_server_example_instance_type"{
  description = "The type of the instance"
  value       = module.default_linux_server_example.instance_type
}

output "default_linux_server_example_public_dns" {
  description = "The public DNS name assigned to the instance (if applicable)."
  value       = module.default_linux_server_example.public_dns
}

output "default_linux_server_example_public_ip" {
  description = "The public IP address assigned to the instance (if applicable)."
  value       = module.default_linux_server_example.public_ip
}

output "default_linux_server_example_private_dns" {
  description = "The private DNS name assigned to the instance."
  value       = module.default_linux_server_example.private_dns
}

output "default_linux_server_example_private_ip" {
  description = "The private IP address assigned to the instance."
  value       = module.default_linux_server_example.private_ip
}

output "default_linux_server_example_security_group_ids" {
  description = "IDs of the security groups assocaited to the instance."
  value       = [module.default_linux_server_example.security_group_ids]
}

output "default_linux_server_example_attached_ebs_volumes" {
  value = module.default_linux_server_example.attached_ebs_volumes
}

output "default_linux_server_example_attached_root_volume" {
  value = module.default_linux_server_example.attached_root_volume
}
