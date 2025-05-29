variable "project_id" {
  type = string
}

####################################
# Postgres Variables
####################################

variable "postgres_name" {
  type = string
}

variable "acl_list" {
  type = list(string)
}

variable "cpu" {
  type = string
}

variable "ram" {
  type = string
}

variable "replicas" {
  type = string
}

variable "class" {
  type = string
}

variable "size" {
  type = string
}

variable "postgres_version" {
  type = string
}

variable "db_name" {
  type = list(string)
}

variable "owner" {
  type = string
}

variable "cron" {
  type = string
}