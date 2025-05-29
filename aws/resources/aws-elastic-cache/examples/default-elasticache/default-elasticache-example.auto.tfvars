region                     = "<insert region here>"
access_key                 = "<insert access_key here>"
secret_key                 = "<insert secret_key here>"
token                      = "<insert token here>"


/* elasticache */
default_elasticache_example_vpc_id                      = "vpc-0b5b83654b21c079c"
default_elasticache_example_resource_name_prefix        = "D1IPV1-TEST"
default_elasticache_example_subnet_ids    =  [
    "subnet-037a9a3d2249b596a",
    "subnet-0a74a146e1e37a0b1",
    "subnet-0b9fd14de1436740f",
    "subnet-0456a1dd3f408540c"
]
default_elasticache_example_security_group_ids    =  [
    "sg-03d1103e1c2119749"
]

default_elasticache_example_cluster_mode_enabled = true
default_elasticache_example_parameter_group_name = "default.redis6.x.cluster.on"
default_elasticache_example_cache_automatic_failover_enabled = true
default_elasticache_example_cache_num_node_groups = 2
default_elasticache_example_cache_replicas_per_node_group = 2
default_elasticache_example_node_at_rest_encryption_enabled = true