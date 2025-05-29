variable "location" {
  type        = string
  description = "the Azure location"
  nullable    = false
}

variable "resource_group" {
  description = "the resource group object"
  nullable    = false
}

variable "env" {
  type        = string
  nullable    = false
  description = "Environment. One of \"dev\", \"prod\" or \"global\"."
  validation {
    condition     = contains(["dev", "prod", "global"], var.env)
    error_message = "Environment must be one of \"dev\", \"prod\" or \"global\"."
  }
}

variable "log_level" {
  type        = string
  description = "Log level of external-dns"
  nullable    = false
  default     = "debug" # TODO: make warning by default
  validation {
    condition     = contains(["panic", "debug", "info", "warning", "error", "fatal", "trace"], var.log_level)
    error_message = "`var.log_level` must be one of (\"panic\", \"debug\", \"info\", \"warning\", \"error\", \"fatal\", \"trace\")."
  }
}

variable "tags" {
  type    = map(string)
  default = { Created_by = "DevOps-Admins-Terragrunted" }
}

variable "server_name" {
  type        = string
  description = "the server name"
  nullable    = false
}

variable "server_size" {
  type        = number
  description = "the DB size"
  nullable    = false
}

variable "server_version" {
  type        = string
  description = "the DB size"
  default     = "12"
}

variable "backup_retention" {
  type        = number
  description = "the DB backup retention in days"
  default     = 31
}

variable "server_sku" {
  type        = string
  description = "the DB SKU name"
  default     = "GP_Gen5_2"
}

variable "db_names" {
  type = list(object({
    name      = string
    collation = string
    charset   = string
  }))
  description = "The list of names of the PostgreSQL Database, which needs to be a valid PostgreSQL identifier. Changing this forces a new resource to be created."
  default     = []
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Enable Geo-redundant or not for server backup. Valid values for this property are Enabled or Disabled, not supported for the basic tier."
  default     = false
}

variable "administrator_login" {
  type        = string
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
}

variable "key_vault" {
  description = "Azure Key Vault object"
  nullable    = false
}

variable "subnet" {
  description = "Vnet Subnet for the postgres deployment"
  type        = string
}

variable "private_dns_zone" {
  description = "Private domain Zone object used for this cluster, e.g., global.ifesw.com."
  nullable    = false
}
