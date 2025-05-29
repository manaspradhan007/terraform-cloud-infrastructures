variable "project_id" {
  type = string
}

####################################
# Kubernetes Cluster Variables
####################################

variable "cluster_name" {
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
  type = bool
}

variable "enable_machine_image_version_updates" {
  type = bool
}

variable "start" {
  type = string
}

variable "end" {
  type = string
}