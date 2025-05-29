variable "create_resource_group" {
  type        = bool
  default     = false
  description = "Bool for creation of resource group"
}

variable "resource_group_name" {
  type        = string
  default     = "test-rg"
  description = "name of the resource group for the vm's"
}

variable "location" {
  type        = string
  default     = "west europe"
  description = "location of the new ressources"
}

variable "ssh_pub_key" {
  type        = string
  description = "ssh-pub-key for connecting to the vm"
  sensitive = true
}

variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1s"
  description = "size of the vm, win and linux (az vm list-sizes --location \"westeurope\" --output table)"
}

variable "login_admin_user" {
  type        = string
  description = "Login user for the vm"
}

variable "ip_configuration_name" {
  type        = string
  default     = "devops-conf1"
  description = "name of the ip_config"
}

variable "vm_subnet_id" {
  type = string
  description = "subnet_id for the network interface"
}

variable "ip_configuration_private_ip_address_allocation" {
  type        = string
  default     = "Dynamic"
  description = "IP address range"
}

variable "create_linux_vm" {
  type        = bool
  default     = true
  description = "create Linux vm if true"
}

variable "create_windows_vm" {
  type        = bool
  default     = false
  description = "create Linux vm if true"
}

variable "source_image_reference_linux_publisher" {
  type        = string
  default     = "Canonical"
  description = "Linux image publisher (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#publisher)"
}

variable "source_image_reference_linux_offer" {
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
  description = "Linux image offer"
}

variable "source_image_reference_linux_sku" {
  type        = string
  default     = "22_04-lts-gen2"
  description = "Linux image sku"
}

variable "source_image_reference_linux_version" {
  type        = string
  default     = "latest"
  description = "Linux image version"
}

variable "source_image_reference_windows_publisher" {
  type        = string
  default     = "MicrosoftWindowsServer"
  description = "Windows image publisher (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine#publisher)"
}

variable "source_image_reference_windows_offer" {
  type        = string
  default     = "WindowsServer"
  description = "Windows image offer"
}

variable "source_image_reference_windows_sku" {
  type        = string
  default     = "2016-Datacenter"
  description = "Windows image sku"
}

variable "source_image_reference_windows_version" {
  type        = string
  default     = "latest"
  description = "Windows image version"
}

variable "vm_name" {
  type        = string
  default     = "testSZ"
  description = "name of the VM"
}

