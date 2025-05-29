variable "region" {
  description = "Location / region to put rescources in"
  default = "West Europe"
  type = string
}

variable "environment" {
  description = "Environment the DB should be created in. E.g. dev, int, stage"
  type = string
}

variable "teamname" {
  description = "Name of the team"
}
variable "server_sku_name" {
  description = "SKU name of the mariaDB server"
  default = "B_Gen5_2"
  type = string
}

variable "server_db_storage_md" {
  description = "Storage in mb for the mariaDB server"
  default = 51200
  type = number 
}

variable "server_backup_retention_days" {
  description = "Retention period in day for backups"
  default = 7
  type = number 
}

variable "server_geo_redundant_backup_enabled" {
  description = "En/Disable geo redundant backups"
  default = false
  type = bool 
}

variable "server_administrator_login" {
  description = "Retention period in day for backups"
  default = 7
  type = number 
}

variable "server_administrator_login_password" {
  description = "Admin user"
  type = string
}

variable "server_version" {
  description = "MariaDB server version"
  default = "10.2"
  type = string
}

variable "server_ssl_enforcement_enabled" {
  description = "Enforce SSL"
  default = true
  type = bool  
}

variable "database_name" {
  description = "Name of the database"
  type = string
}

variable "database_charset" {
  description = "Charset for the database"
  default = "utf8mb4"
  type = string
}

variable "database_collation" {
  description = "Collation for the database"
  default = "utf8mb4_unicode_520_ci"
  type = string 
}