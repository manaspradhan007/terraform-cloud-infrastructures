variable "project_id" {
  type = string
}
####################################
# Kubernetes CLuster Variables
####################################

variable "cluster_name" {
  type = string
}

variable "nodepool_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "maximum" {
  type = string
}

variable "minimum" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "os_name" {
  type = string
}

variable "os_version" {
  type = string
}

variable "allowed_cidrs_list" {
  type = list(string)
}

variable "zones" {
  type = list(string)
}
variable "acl_enabled" {
  type = bool
}

variable "enable_kubernetes_version_updates" {
  type    = bool
  default = false
}

variable "enable_machine_image_version_updates" {
  type    = bool
  default = false
}

variable "start" {
  type    = string
  default = "01:00:00Z"
}

variable "end" {
  type    = string
  default = "02:00:00Z"
}

variable "volume_size" {
  type = string
}

variable "volume_type" {
  type = string
}

variable "taints" {
  type = string
}
variable "cpu_volume_size" {
  type = string
}
variable "cpu_availability_zones" {
  type = list(string)
}
variable "cpu_maximum" {
  type = string
}
variable "cpu_minimum" {
  type = string
}
variable "cpu_machine_type" {
  type = string
}
variable "cpu_nodepool_name" {
  type = string
}
variable "cpu_volume_type" {
  type = string
}