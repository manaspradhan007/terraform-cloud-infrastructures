output "instance_id" {
  description = "The Instance ID."
  value = element(
    concat(
      aws_instance.without_customscript.*.id,
      aws_instance.with_customscript.*.id,
      [""],
    ),
    0,
  )
}

output "key_name" {
  description = "The key name of the instance."
  value = element(
    concat(
      aws_instance.without_customscript.*.key_name,
      aws_instance.with_customscript.*.key_name,
      [""],
    ),
    0,
  )
}

output "instance_type" {
  description = "The type of the Instance"
  value       = element(
    concat(
      aws_instance.without_customscript.*.instance_type,
      aws_instance.with_customscript.*.instance_type,
      [""],
    ),
    0,
  )
}


output "public_dns" {
  description = "The public DNS name assigned to the instance (if applicable)."
  value = element(
    concat(
      aws_instance.without_customscript.*.public_dns,
      aws_instance.with_customscript.*.public_dns,
      [""],
    ),
    0,
  )
}

output "public_ip" {
  description = "The public IP address assigned to the instance (if applicable)."
  value = element(
    concat(
      aws_instance.without_customscript.*.public_ip,
      aws_instance.with_customscript.*.public_ip,
      [""],
    ),
    0,
  )
}

output "private_dns" {
  description = "The private DNS name assigned to the instance."
  value = element(
    concat(
      aws_instance.without_customscript.*.private_dns,
      aws_instance.with_customscript.*.private_dns,
      [""],
    ),
    0,
  )
}

output "private_ip" {
  description = "The private IP address assigned to the instance."
  value = element(
    concat(
      aws_instance.without_customscript.*.private_ip,
      aws_instance.with_customscript.*.private_ip,
      [""],
    ),
    0,
  )
}

output "security_group_ids" {
  description = "IDs of the security groups assocaited to the instance."
  value       = [local.sg_ids]
}

output "attached_ebs_volumes" {
  value = local.Ebs_volume_attached
}

output "attached_root_volume" {
  value = local.Root_volume_attached
}

