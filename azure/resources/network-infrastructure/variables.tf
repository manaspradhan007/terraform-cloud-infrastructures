variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "resource_group_name" {
  type        = string
  description = "name of the resource group"
}

variable "virtual_network_name" {
  type        = string
  description = "name of the virtual network"
}

variable "location" {
  type        = string
  description = "name of the location"
}

variable "address_space" {
  type        = list(string)
  description = "address space range to be assigned to the vnet"
}

variable "subnet_names" {
  type = list(object({
    name          = string
    address_space = string
  }))
  description = "subnet details"
}

variable "hub_resource_group_name" {
  type        = string
  description = "name of the hub side resource group"
}

variable "hub_network_name" {
  type        = string
  description = "name of the hub side vnet"
}

variable "environment_short" {
  type = string
}

variable "hub_network_id" {
  type        = string
  description = "fully qualified path to the hub side vnet or the id of the hub vnet"
}
