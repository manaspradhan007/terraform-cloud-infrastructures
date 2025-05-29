variable "environment_short" {
  description = "short name of the environment e.g dev, int, stage"
  type        = string
}

variable "environment_long" {
  type        = string
  description = "full or long name of the environment e.g develop, integration, staging"
}

variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "create_azure_monitor_extended_resources" {
  type = bool
}

variable "cluster_name" {
  type = string
}

variable "private_dns_zone_id" {
  type        = string
  description = "description"
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_name_hub" {
  type = string
}

variable "location" {
  type = string
}

variable "kubernetes_vnet_name" {
  type = string
}

variable "kubernetes_vnet_id" {
  type = string
}

variable "analytics_workspace_daily_quota" {
  type    = number
  default = 1
}

variable "analytics_workspace_sku" {
  type    = string
  default = "PerGB2018"
}

variable "analytics_workspace_retention_days" {
  type    = number
  default = 30
}

variable "system_nodepool_name" {
  type    = string
  default = "system"
}

variable "system_nodepool_node_count" {
  type    = number
  default = 1
}

variable "system_nodepool_node_max_count" {
  type    = number
  default = 5
}

variable "system_nodepool_node_min_count" {
  type    = number
  default = 1
}

variable "system_nodepool_node_tier" {
  type    = string
  default = "Standard_D2s_v4"
}

variable "user_nodepool1_name" {
  type    = string
  default = "user1"
}

variable "user_nodepool1_node_count" {
  type    = number
  default = 1
}

variable "user_nodepool1_node_max_count" {
  type    = number
  default = 12
}

variable "user_nodepool1_node_min_count" {
  type    = number
  default = 1
}

variable "user_nodepool1_node_tier" {
  type    = string
  default = "Standard_D4s_v4"
}

variable "storage_account_id" {
  type = string
}

variable "cluster_logs_archive_rentention_days" {
  type    = number
  default = 90
}

variable "kubernetes_version" {
  description = "Version of the kuberntes cluster"
  type        = string
}

variable "vault_name" {
  description = "Name of the vault if you want to change it to some non default name"
  type        = string
}

variable "vault_purge_protection_enabled" {
  description = "Purge protection of secrets stored in vault"
  type        = bool
  default     = true
}

variable "vault_sku" {
  description = "sku of the key vault"
  type        = string
  default     = "standard"
}

variable "vault_soft_delete_retention_days" {
  description = "soft delete retention days for secrets in key vault"
  type        = number
  default     = 90
}

variable "subnet_id" {
  type        = string
  description = "description"
}

variable "subnet_name" {
  type        = string
  description = "description"
}

variable "oidc_issuer_enabled" {
  type        = bool
  default     = false
  description = "Enable OIDC on the AKS Cluster"
}

variable "tenant_id" {
  type = string
}
