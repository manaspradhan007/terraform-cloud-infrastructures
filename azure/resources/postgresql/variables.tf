variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "subscription_id" {
  type = string
}

variable "location" {
  type        = string
  description = "The azure location used for azure"
  default     = "West Europe"
}

variable "project" {
  type        = string
  description = "Project"
}

variable "database_suffixes" {
  type        = list(string)
  description = "List of suffixes for databases to be created"
}

variable "database_version" {
  type        = string
  description = "Database version to use"
}

variable "suffix" {
  type        = string
  description = "Naming suffix to allow multiple instances of this module"
  default     = ""
}

variable "charset" {
  type        = string
  description = "Charset for the databases, which needs to be a valid PostgreSQL charset"
}

variable "collation" {
  type        = string
  description = <<EOF
    Collation for the databases, which needs to be a valid PostgreSQL collation. Note that *for single server* Microsoft
    uses different notation - f.e. en-US instead of en_US. *For flexible server*, PostgreSQL standard collations are
    used. https://www.postgresql.org/docs/current/collation.html
EOF
}

variable "backup_retention_days" {
  type        = number
  description = "Number of days to keep backups"
  default     = 15
  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 35
    error_message = "Backup retention days has to be between 7 and 35 including."
  }
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = <<EOF
    Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant
    backup storage in the General Purpose and Memory Optimized tiers. This is not support for the Basic tier
    (only single server)
EOF
  default     = false
}

variable "admin_username" {
  description = "Admin login"
  type        = string
}

variable "admin_password" {
  description = "The password associated with the admin_username user"
  default     = null
}

variable "database_host_sku" {
  type        = string
  description = <<EOF
    SKU for the database server to use. Single server uses values like GP_Gen5_2, flexible server uses Azure
    machine SKUs like GP_Standard_D2s_v3
EOF
  # default     = "GP_Standard_D4s_v3"
}

variable "database_storage" {
  type        = string
  description = <<EOF
    Required database storage (in MB) (flexible server has a defined set of storage sizes to select from.
    See https://docs.microsoft.com/de-de/azure/postgresql/flexible-server/concepts-compute-storage#storage
EOF
  default     = "32768"
}

variable "database_flexible" {
  type        = bool
  description = "Whether to use Azure's flexible database service"
  default     = true
}

variable "public_access" {
  type        = bool
  description = <<EOF
    Wether to allow public access to the database server. True will create firewall rules for allowed_ips and for
    subnets. False will create a private endpoint in each given subnet (allowed_ips will not be used then) - you have
    to set `enforce_private_link_endpoint_network_policies = true` on your subnet in this case (see
    https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#enforce_private_link_endpoint_network_policies).
    (false currently not supported for flexible server)
EOF
  default     = false
}

variable "allowed_ips" {
  type = map(object({
    start = string,
    end   = string
  }))
  description = <<EOF
    A hash of permissions to access the database server by ip. The hash key is the name suffix and each value
    has a start and an end value. For public access set start_ip_address to 0.0.0.0 and end_ip_address to
    255.255.255.255. This variable is not used if public_access = false.
EOF
  default     = {}
}

variable "availability_zone" {
  default     = 1
  description = "The availability zone the Flexible Server should be placed in (only flexible server)"
}

variable "environment_short" {
  description = "environment such as dev, int, stage, demo"
  type        = string
}

variable "environment_long" {
  type = string
}

variable "resource_group_name_hub" {
  description = "Default network resource group"
}

variable "network_name_hub" {
  type        = string
  description = "Name of hub network"
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group"
}

variable "postgresql_server_subnet_address" {
  type        = string
  description = "Subnet address get it from DevOps"
}

variable "create_postgresql_resource" {
  description = "Whether to create Azure's resource group"
  type        = bool
  default     = false
}

variable "privatelink" {
  description = "Default for existing privatelink DNS zone"
  default     = "privatelink.postgres.database.azure.com" #https://github.com/hashicorp/terraform-provider-azurerm/issues/20847
}

variable "identity" {
  description = "If you want your SQL Server to have an managed identity. Defaults to false."
  default     = true
}

variable "database_availability_rule_is_paused" {
  type = bool
}
