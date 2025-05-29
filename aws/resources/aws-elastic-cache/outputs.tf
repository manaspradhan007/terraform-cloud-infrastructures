output "cache_sg_id" {
  description = "The ID of the cache security group"
  value       = element(concat(aws_security_group.cache_sg.*.id, [""]), 0)
}

output "cache_endpoint" {
  description = "The cache endpoint."
  value = "${element(concat(var.cluster_mode_enabled ? compact(concat(aws_elasticache_replication_group.redis_replication.*.configuration_endpoint_address, aws_elasticache_replication_group.redis_replication.*.primary_endpoint_address)) : compact(concat(aws_elasticache_replication_group.redis_replication_cluster_off.*.configuration_endpoint_address, aws_elasticache_replication_group.redis_replication_cluster_off.*.primary_endpoint_address)), [""]), 0)}:${var.cache_port}"
}

output "cache_cluster_id" {
  description = "The ID of the cache cluster"
  value       = element(concat(var.cluster_mode_enabled ? aws_elasticache_replication_group.redis_replication.*.id : aws_elasticache_replication_group.redis_replication_cluster_off.*.id, [""]), 0)
}