module "default_elasticache_example" {
  source = "../../"

  vpc_id               = var.default_elasticache_example_vpc_id
  resource_name_prefix = var.default_elasticache_example_resource_name_prefix
  security_group_ids   = var.default_elasticache_example_security_group_ids
  subnet_ids           = var.default_elasticache_example_subnet_ids
  cache_required       = true
  cluster_mode_enabled         = var.default_elasticache_example_cluster_mode_enabled
  cache_num_node_groups = var.default_elasticache_example_cache_num_node_groups
  cache_replicas_per_node_group = var.default_elasticache_example_cache_replicas_per_node_group
  cache_automatic_failover_enabled = var.default_elasticache_example_cache_automatic_failover_enabled
  parameter_group_name = var.default_elasticache_example_parameter_group_name
  node_at_rest_encryption_enabled = var.default_elasticache_example_node_at_rest_encryption_enabled
}

