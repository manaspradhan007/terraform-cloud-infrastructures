variable "cluster_name" {
  type    = string
  description = "The AKS cluster name"
}

variable "location" {
  type = string
  description = "Resource group location"
}

variable "resource_group_name" {
  type = string
  description = "The resource group name"
}

variable "monitor_account_name" {
  type = string
  description = "Name of the Monitoring account"
}

variable "monitor_workspace_id" {
  type = string
  description = "The Azure Monitor Workspace id"
}

variable "prometheus_forwarder_name" {
  type = string
  description = "Data source forwarder name"
}

variable "streams" {
  type = string
  description = "Data source streams"
}

variable "target_aks_id" {
  type = string
  description = "Target AKS cluster id"
}