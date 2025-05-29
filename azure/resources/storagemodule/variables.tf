variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
  type        = bool
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
  type        = string
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "westeurope"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the azure storage account"
  default     = ""
  type        = string
}

variable "account_kind" {
  description = "The type of storage account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  default     = "StorageV2"
  type        = string
}

variable "skuname" {
  description = "The SKUs supported by Microsoft Azure Storage. Valid options are Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, Standard_LRS, Standard_RAGRS, Standard_RAGZRS, Standard_ZRS"
  default     = "Standard_LRS"
  type        = string
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cool."
  default     = "Hot"
  type        = string
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  default     = "TLS1_2"
  type        = string
}

variable "blob_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
  type        = number
}

variable "container_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
  type        = number
}

variable "enable_versioning" {
  description = "Is versioning enabled? Default to `false`"
  default     = false
  type        = bool
}

variable "last_access_time_enabled" {
  description = "Is the last access time based tracking enabled? Default to `false`"
  default     = false
  type        = bool
}

variable "change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled?"
  default     = false
  type        = bool
}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  default     = false
  type        = bool
}

variable "network_rules" {
  description = "Network rules restricing access to the storage account."
  type        = object({ bypass = list(string), ip_rules = list(string), subnet_ids = list(string) })
  default     = null
}

variable "containers_list" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "file_shares" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "queues" {
  description = "List of storages queues"
  type        = list(string)
  default     = []
}

variable "tables" {
  description = "List of storage tables."
  type        = list(string)
  default     = []
}
variable "lifecycles" {
  description = "Configure Azure Storage firewalls and virtual networks"
  type        = list(object({ prefix_match = set(string), tier_to_cool_after_days = number, tier_to_archive_after_days = number, delete_after_days = number, snapshot_delete_after_days = number }))
  default     = []
}

variable "managed_identity_type" {
  description = "The type of Managed Identity which should be assigned to the Linux Virtual Machine. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`"
  default     = null
  type        = string
}

variable "managed_identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned to the Linux Virtual Machine."
  default     = null
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {Created-by = "DevOps-admins-terraformed"}
}

variable "resource_group_name_hub" {
  description = "default resource groupname hub"
  type  = string
}

variable "vnet_name" {
  description = "default network name hub"
  type = string
}

variable "storageaccount_subnet_address" {
  description = "Address prefixes of the available subnet in the network"
  type = list(string)
  default = [""]
}

variable "teamname" {
  description = "Team name"
  type = string
}

variable "env" {
  description = "Environment name"
  type = string
}

variable "account_tier" {
  description = "account_tier"
  type = string
  default = "Standard"
}

variable "virtual_network_name" {
  type        = string
  default     = ""
  description = "description"
}


variable "private_dns_zone_id" {
  type        = list(string)
  default     = []
  description = "description"
}


variable "privatelinkfile" {
  type = string
  default = "privatelink.file.core.windows.net"
}

variable "privatelinkblob" {
  type = string
  default = "privatelink.blob.core.windows.net"
}

variable "account_replication_type" {
  description = "account_replication_type"
  type = string
  default = "LRS"
}

variable "azurerm_storage_account_network_rule_default_action" {
  default = "Deny"
  type = string
}

variable "azurerm_storage_account_network_rules_bypass" {
  default = ["AzureServices"]
  type = list(string)
}

variable "azurerm_storage_account_network_rules_ip_rules" {
  default = []
  type = list(string)
}

variable "static_website" {
  type = list( object({
    index_document = string,
    error_404_document = string
  }))
  default = null
}
variable "num" {
  type        = string
}
variable "vnet_resource_group" {
  type        = string
}
