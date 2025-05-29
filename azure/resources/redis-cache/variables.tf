variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = true
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "westeurope"
}

variable "log_analytics_workspace_name" {
  description = "The name of log analytics workspace name"
  default     = null
}

variable "redis_instance_name" {
  description = "The name of the Redis instance"
  default     = ""
}

variable "redis_family" {
  type        = map(any)
  description = "The SKU family/pricing group to use. Valid values are `C` (for `Basic/Standard` SKU family) and `P` (for `Premium`)"
  default = {
    Basic    = "C"
    Standard = "C"
    Premium  = "P"
  }
}

variable "redis_server_settings" {
  type = map(object({
    capacity                      = number
    sku_name                      = string
    enable_non_ssl_port           = optional(bool)
    minimum_tls_version           = optional(string)
    private_static_ip_address     = optional(string)
    public_network_access_enabled = optional(string)
    replicas_per_master           = optional(number)
    shard_count                   = optional(number)
    zones                         = optional(list(string))
  }))
  description = "optional redis server setttings for both Premium and Standard/Basic SKU"
  default     = {}
}

variable "patch_schedule" {
  type = object({
    day_of_week    = string
    start_hour_utc = number
  })
  description = "The window for redis maintenance. The Patch Window lasts for 5 hours from the `start_hour_utc` "
  default     = null
}

variable "subnet_id" {
  description = "The ID of the Subnet within which the Redis Cache should be deployed. Only available when using the Premium SKU"
  default     = null
}

variable "redis_configuration" {
  type = object({
    enable_authentication           = optional(bool)
    maxmemory_reserved              = optional(number)
    maxmemory_delta                 = optional(number)
    maxmemory_policy                = optional(string)
    maxfragmentationmemory_reserved = optional(number)
    notify_keyspace_events          = optional(string)
  })
  description = "Configuration for the Redis instance"
  default     = {}
}

variable "storage_account_name" {
  description = "The name of the storage account name"
  default     = null
}

variable "enable_data_persistence" {
  description = "Enable or disbale Redis Database Backup. Only supported on Premium SKU's"
  default     = false
}

variable "data_persistence_backup_frequency" {
  description = "The Backup Frequency in Minutes. Only supported on Premium SKU's. Possible values are: `15`, `30`, `60`, `360`, `720` and `1440`"
  default     = 60
}

variable "data_persistence_backup_max_snapshot_count" {
  description = "The maximum number of snapshots to create as a backup. Only supported for Premium SKU's"
  default     = 1
}

variable "firewall_rules" {
  description = "Range of IP addresses to allow firewall connections."
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "teamname" {
  description = "team name"
  type        = string
}

variable "resource_group_name_hub" {
  type        = string
  description = "Default network resource group to get the dns zone and subnet for privatelink"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network in which privatelink subnet and dns zone exists"
}

variable "env" {
  type        = string
  description = "Name of the environment. Example dev, test, qa, cert, prod etc...."
}

variable "privlink_subresource_names" {
  description = "A list of subresource names which the Private Link Endpoint is able to connect to. Changing this forces a new resource to be created."
  type        = list(string)
  default     = null
}

variable "ad_group_id" {
  type        = string
  description = "ID of Azure Active Directory Group to make Contributor"
}

variable "privatelink_subnet_id" {
  type = string
  description = "Azure resource ID of subnet that will hold private endpoint"
}