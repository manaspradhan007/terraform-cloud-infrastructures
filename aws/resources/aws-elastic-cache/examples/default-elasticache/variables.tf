variable "default_elasticache_example_vpc_id" {
}

variable "default_elasticache_example_resource_name_prefix" {
}

variable "default_elasticache_example_security_group_ids" {
  type = list(string)
}

variable "default_elasticache_example_subnet_ids" {
  type = list(string)
}

variable "default_elasticache_example_cluster_mode_enabled" {
}

variable "default_elasticache_example_cache_num_node_groups" {
}

variable "default_elasticache_example_cache_replicas_per_node_group" {
}

variable "default_elasticache_example_cache_automatic_failover_enabled" {
}

variable "default_elasticache_example_parameter_group_name" {
}

variable "default_elasticache_example_node_at_rest_encryption_enabled" {
}
