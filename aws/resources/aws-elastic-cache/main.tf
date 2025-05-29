##########################
#  Cache Security Group  #
##########################

resource "aws_security_group" "cache_sg" {
  count = var.cache_required ? 1 : 0
  name = format(
    "%s-%s",
    var.resource_name_prefix,
    "ELASTICACHE-RESOURCES-CacheSg",
  )
  description = format(
    "Auto-generated Security Group for %s-%s",
    var.resource_name_prefix,
    "Cache",
  )
  vpc_id = var.vpc_id
  ingress {
    from_port       = var.cache_port
    to_port         = var.cache_port
    protocol        = var.ingress_protocol
    security_groups = var.security_group_ids
  }
  dynamic "egress" {
    for_each = var.default_sg_egress_rules
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      description      = lookup(egress.value, "description", null)
      from_port        = lookup(egress.value, "from_port", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      protocol         = lookup(egress.value, "protocol", null)
      security_groups  = lookup(egress.value, "security_groups", null)
      self             = lookup(egress.value, "self", null)
      to_port          = lookup(egress.value, "to_port", null)
    }
  }
  tags = merge(
    {
      "Name" = format("%s-%s", var.resource_name_prefix, "CacheSg")
    },
    var.tags,
    var.default_sg_tags,
  )
}

##########################
#   Cache Subnet Group   #
##########################
resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  count       = var.cache_required ? 1 : 0
  name        = format("%s-%s", lower(var.resource_name_prefix), "subnet-group")
  description = var.cache_subnet_group_desription
  subnet_ids  = flatten(var.subnet_ids)
}

resource "random_id" "redis_replication_rand" {
  count       = var.cache_required ? 1 : 0
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    node_at_rest_encryption_enabled = "${var.node_at_rest_encryption_enabled}"
  }

  byte_length = 8
}

#######################
#  Redis Replication  #
#######################
resource "aws_elasticache_replication_group" "redis_replication" {
  count                         = (var.cache_required && var.cluster_mode_enabled) ? 1 : 0
  automatic_failover_enabled    = var.cache_automatic_failover_enabled
  replication_group_id          = format("%s-%s-%s", var.resource_name_prefix, "CLUSTER", "${random_id.redis_replication_rand[0].keepers.node_at_rest_encryption_enabled == "true" ? "e" : "ue" }")
  replication_group_description = "Elasticache for Redis"
  node_type                     = var.cache_node_type
  port                          = var.cache_port
  parameter_group_name          = var.parameter_group_name
  availability_zones            = var.availability_zones
  auto_minor_version_upgrade    = var.engine_auto_minor_version_upgrade
  at_rest_encryption_enabled    = var.node_at_rest_encryption_enabled
  apply_immediately             = var.modify_apply_immediately
  cluster_mode {
    replicas_per_node_group = var.cache_replicas_per_node_group
    num_node_groups         = var.cache_num_node_groups
  }
  snapshot_window          = var.cache_snapshot_window
  maintenance_window       = var.preferred_maintenance_window
  snapshot_retention_limit = var.cache_snapshot_retention_limit
  subnet_group_name        = aws_elasticache_subnet_group.cache_subnet_group[0].name
  security_group_ids       = [aws_security_group.cache_sg[0].id]
  tags = merge(
    {
      "Name" = format("%s-%s-%s", var.resource_name_prefix, "REDIS", random_id.redis_replication_rand[0].hex)
    },
    var.tags,
    var.default_redis_tags,
  )
}

resource "aws_elasticache_replication_group" "redis_replication_cluster_off" {
  count                         = (var.cache_required && !var.cluster_mode_enabled) ? 1 : 0
  automatic_failover_enabled    = var.cache_automatic_failover_enabled
  replication_group_id          = format("%s-%s-%s", var.resource_name_prefix, "NON-CLUSTER", "${random_id.redis_replication_rand[0].keepers.node_at_rest_encryption_enabled == "true" ? "e" : "ue" }")
  replication_group_description = "Elasticache for Redis"
  node_type                     = var.cache_node_type
  port                          = var.cache_port
  parameter_group_name          = var.parameter_group_name
  availability_zones            = var.availability_zones
  auto_minor_version_upgrade    = var.engine_auto_minor_version_upgrade
  at_rest_encryption_enabled    = var.node_at_rest_encryption_enabled
  apply_immediately             = var.modify_apply_immediately
  number_cache_clusters         = "${var.cache_replicas_per_node_group + 1}"
  snapshot_window          = var.cache_snapshot_window
  maintenance_window       = var.preferred_maintenance_window
  snapshot_retention_limit = var.cache_snapshot_retention_limit
  subnet_group_name        = aws_elasticache_subnet_group.cache_subnet_group[0].name
  security_group_ids       = [aws_security_group.cache_sg[0].id]
  tags = merge(
    {
      "Name" = format("%s-%s-%s", var.resource_name_prefix, "REDIS", random_id.redis_replication_rand[0].hex)
    },
    var.tags,
    var.default_redis_tags,
  )
}
