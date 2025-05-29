output "default_elasticache_example_cache_sg_id" {
  description = "The ID of the cache security group"
  value       = module.default_elasticache_example.cache_sg_id
}

output "default_elasticache_example_cache_endpoint" {
  description = "The address of the replication group configuration endpoint when cluster mode is enabled."
  value       = module.default_elasticache_example.cache_endpoint
}

output "default_elasticache_example_cache_cluster_id" {
  description = "The ID of the cache cluster"
  value       = module.default_elasticache_example.cache_cluster_id
}
