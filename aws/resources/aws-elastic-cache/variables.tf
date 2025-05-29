####################
#  Security Group  #
####################

variable "resource_name_prefix" {
  description = "Name prefix to be used to derive names for all the resources."
  default     = ""
}

variable "cache_required" {
  description = "Master control to create the cache or not"
  type        = bool
}

variable "default_sg_egress_rules" {
  description = "List of Egress Rules for the default Security Group"
  type        = list(any)
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

variable "vpc_id" {
  description = "The identifier for the VPC"
  default     = ""
}

variable "security_group_ids" {
  description = "List of security group ids for ingress"
  type        = list(string)
  default     = []
}

variable "ingress_protocol" {
  description = "Cache ingress protocol"
  default     = "tcp"
}

##################
#  Subnet Group  #
##################
variable "subnet_ids" {
  description = "The identifiers for the subnets"
  default     = []
}

variable "cache_subnet_group_name" {
  description = "The cache subnet group name"
  default     = ""
}

variable "cache_subnet_group_desription" {
  description = "The cache subnet group description"
  default     = "Cache Subnet Group"
}

#####################
# Redis Replication #
#####################

variable "cluster_mode_enabled" {
  type = bool
  description = "Set cluster mode of the redis cache"
  default = true
}

variable "cache_node_type" {
  description = "The cache node type"
  default     = "cache.t2.medium"
}

variable "cache_port" {
  description = "The cache port"
  default     = 6379
}

variable "cache_num_node_groups" {
  description = "The number of cache node groups"
  default     = 2
}

variable "cache_automatic_failover_enabled" {
  description = "The cache automatic failover enabled flag"
  default     = true
}

variable "cache_replicas_per_node_group" {
  description = "Number of cache replicas per node group"
  default     = 1
}

variable "cache_snapshot_retention_limit" {
  description = "The cache snapshot retention limit"
  default     = 1
}

variable "cache_snapshot_window" {
  description = "the cache snapshot window"
  default     = "01:00-02:00"
}

variable "preferred_maintenance_window" {
  description = "The preferred maintenance window"
  default     = "sun:05:00-sun:06:00"
}

variable "parameter_group_name" {
  description = "The name of the parameter group to associate with this replication group. If this argument is omitted, the default cache parameter group for the specified engine is used."
  default     = ""
}

variable "availability_zones" {
  description = "A list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is not important."
  default     = []
}

variable "engine_auto_minor_version_upgrade" {
  description = "Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window"
  default     = true
}

variable "node_at_rest_encryption_enabled" {
  description = "Whether to enable encryption at rest."
  default     = true
}

variable "modify_apply_immediately" {
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window"
  default     = true
}

##########
#  Tags  #
##########

variable "tags" {
  description = "A map of tags to add to all resources."
  default     = {}
}

variable "default_sg_tags" {
  description = "Additional tags for the Security Group."
  default     = {}
}

variable "default_redis_tags" {
  description = "Additional tags for Redis"
  default     = {}
}

