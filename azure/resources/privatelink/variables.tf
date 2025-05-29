variable "project" {
  type        = string
  description = "Three letter project key"
}

variable "env" {
  type        = string
  description = "Name of the environment. Example dev, test, qa, cert, prod etc...."
}

variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
}

variable "resource_group_name_hub" {
  type        = string
  description = "Default network resource group to get the dns zone and subnet for privatelink"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network in which privatelink subnet and dns zone exists"
}

variable "privatelink_subnet_name" {
  type        = string
  description = "Subnet to create privatelink"
  default     = "" #"KubernetesResources"
}

variable "name" {
  type        = string
  description = "name for private link"
}
variable "location" {
  type        = string
  description = "name of the location"
}
variable "resource_id" {
  type        = string
  description = "Resource id for which creating this private link"
}

variable "is_manual_connection" {
  type        = bool
  description = "Used when private link is created for something deployed on virtual machines"
  default     = false
}

variable "subresource_names" {
  type        = list(string)
  description = "List of subresource names like, blob, fileshare, mongo etc."
  default     = null
}

variable "linktype" {
  description = "The type of link that is attached to e.g. redis, cosmos-mongo, Blobstorage"
  type        = string
  validation {
    condition     = contains(["redis", "cosmos-mongo", "blob", "vault"], lower(var.linktype))
    error_message = "Valid values for var: linktype are (redis, cosmos-mongo, blobstorage)."
  }
}

variable "private_dns_zone_id" {
  type        = list(string)
  default     = []
  description = "description"
}

variable "subnet_id" {
  type        = string
  description = "description"
}
