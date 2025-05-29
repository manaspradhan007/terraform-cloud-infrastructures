#####################################
#Firewall Variables
#####################################
variable "create_resource_group" {
  type        = bool
  description = "Whether to create a resource group or not"
}

variable "create_new_network" {
  type        = bool
  default     = true
  description = "create new network for firewall in the subscription"
}

variable "deploy_in_hub" {
  type        = bool
  default     = true
  description = "deploy in hub subscription"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "name of the location"
}

variable "firewall_resource_group_name" {
  type        = string
  description = "name of the resource group"
}

variable "firewall_network_security_group_name" {
  type        = string
  description = "name of the network security group"
}

variable "firewall_virtual_network_name" {
  type        = string
  description = "name of the virtual network"
}

variable "firewall_address_space" {
  type        = list(string)
  description = "address space range to be assigned to the vnet"
}

variable "firewall_subnet_names" {
  type        = map(string)
  description = "subnet details"
}

variable "firewall_env" {
  type        = string
  description = "name of the environment"
}

variable "firewall_hub_resource_group_name" {
  description = "default resource group name hub"
  type        = string
}

variable "firewall_hub_network_name" {
  type = string
}

variable "firewall_hub_to_env_link_name" {
  type        = string
  description = "description"
  default     = "hub-prod-firewall-link"
}

variable "hub_network_id" {
  type        = string
  description = "fully qualified path to the hub side vnet or the id of the hub vnet"
  default     = "/subscriptions/<subscription-id>/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/<network-name>"
}

variable "firewall_env_to_hub_link_name" {
  type        = string
  description = "description"
  default     = "prod-firewall-hub-link"
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = { Created-by = "DevOps-admins-terraformed" }
}

variable "firewall_name" {
  type        = string
  description = "Specifies the name of the Firewall in which the NAT Rule Collection should be created."
}

variable "resource_group_name" {
  type        = string
  description = "Specifies the name of the Resource Group in which the Firewall exists."
}

variable "hub_network_rg" {
  type        = string
  description = "description"
}
variable "hub_network_name" {
  type        = string
  description = "description"
}
variable "firewall_subnet_address_prefix" {
  type        = list(string)
  default     = [""]
  description = "description"
}
