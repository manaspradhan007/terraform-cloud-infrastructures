variable "project" {
  type        = string
  description = "Three letter project key"
}

variable "environment_short" {
  type        = string
  description = "Name of the environment. Example dev, test, qa, cert, prod etc...."
}

variable "environment_long" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "prefix" {
  type        = string
  description = "Used with environment and project in case more than one resources are required for same project in same environment."
  default     = "01"
}

variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = true
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
}

variable "location" {
  type        = string
  description = "Cosmos DB deployment region. Can be different vs. RG location"
}

variable "resource_group_name_hub" {
  type        = string
  description = "Default network resource group to get the dns zone and subnet for privatelink"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network in which privatelink subnet and dns zone exists"
}

variable "ad_group_id" {
  type        = string
  description = "ID of Azure Active Directory Group to make Contributor"
}

variable "cosmos_account_name" {
  type        = string
  description = "Name of the Cosmos DB account."
  default     = ""
}

variable "cosmos_api" {
  type        = string
  description = ""
  validation {
    condition     = contains(["sql", "table", "cassandra", "mongo", "gremlin"], lower(var.cosmos_api))
    error_message = "Unsupported cosmos api specified. Supported APIs include sql, table, cassandra, mongo and gremlin."
  }
  default = "mongo"
}

variable "mongo_server_version" {
  type        = number
  description = "Version for the mongo db server and api"
}

variable "offer_type" {
  type        = string
  description = "Type to use for this resource eg. Standard or Premium"
  default     = "Standard"
}

variable "consistency_level" {
  type        = string
  description = "The Consistency Level to use for this CosmosDB Account - can be either BoundedStaleness, Eventual, Session, Strong or ConsistentPrefix"
  default     = "Session"
}

variable "auto_failover" {
  type        = bool
  description = "Enable automatic fail over for this Cosmos DB account - can be either true or false"
  default     = false
}

variable "free_tier" {
  type        = bool
  description = "Enable Free Tier pricing option for this Cosmos DB account - can be either true or false"
  default     = false
}

variable "multi_region_write" {
  type        = bool
  description = "Enable multiple write locations for this Cosmos DB account"
  default     = false
}

variable "backup_enabled" {
  type        = bool
  description = "Enable backup for this Cosmos DB account"
  default     = true
}

variable "backup_type" {
  type        = string
  description = "Type of backup - can be either Periodic or Continuous"
  default     = "periodic"
}

variable "backup_interval" {
  type        = number
  description = "The interval in minutes between two backups. This is configurable only when type is Periodic. Possible values are between 60 and 1440."
  default     = 1440
}

variable "backup_retention" {
  type        = number
  description = "The time in hours that each backup is retained. This is configurable only when type is Periodic. Possible values are between 8 and 720."
  default     = 336
}

variable "backup_storage_redundancy" {
  type        = string
  description = "he storage redundancy which is used to indicate type of backup residency. This is configurable only when type is Periodic. Possible values are Geo, Local and Zone"
  default     = "Local"
}


variable "geo_locations" {
  description = "List of map of geo locations and other properties to create primary and secodanry databasees."
  type        = any
  default = [
    {
      geo_location      = "West Europe"
      failover_priority = 0
      zone_redundant    = false
    },
  ]
}

variable "capabilities" {
  type        = map(any)
  description = "Map of non-sql DB API to enable support for API other than SQL"
  default = {
    sql       = "SQL"
    table     = "EnableTable"
    gremlin   = "EnableGremlin"
    mongo     = "EnableMongo"
    cassandra = "EnableCassandra"
  }
}

variable "additional_capabilities" {
  type        = list(string)
  description = "List of additional capabilities for Cosmos DB API. - possible options are DisableRateLimitingResponses, EnableAggregationPipeline, EnableServerless, mongoEnableDocLevelTTL, MongoDBv3.4, AllowSelfServeUpgradeToMongo36"
  default     = ["DisableRateLimitingResponses", "EnableServerless"]
}

variable "is_virtual_network_filter_enabled" {
  type        = bool
  description = "TODO"
  default     = false
}

variable "local_authentication_disabled" {
  type        = bool
  description = "Local authentication flag"
  default     = false
}

variable "access_key_metadata_writes_enabled" {
  type        = bool
  description = "Enable creation of DB and Collections from Client"
  default     = true
}

variable "enable_systemassigned_identity" {
  type        = bool
  description = "Enable System Assigned Identity"
  default     = false
}
/*
  The following section contains firewall parameters
*/
variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public network access to cosmos db"
  default     = false
}

variable "ip_firewall_enabled" {
  type        = bool
  description = "Enable ip firewwall to allow connection to this cosmosdb from client's machine and from azure portal."
  default     = true
}

variable "firewall_ip" {
  type        = list(string)
  description = "List of ip address to allow access from the internet or on-premisis network."
  default     = []
}

variable "azure_portal_access" {
  type        = list(string)
  description = "List of ip address to enable the Allow access from the Azure portal behavior."
  default     = ["104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26"]
}

variable "privatelink_subnet_id" {
  type        = string
  description = "Azure resource ID of subnet that will hold private endpoint"
}

variable "database_availability_rule_is_paused" {
  type = bool
}
