data "azurerm_resource_group" "default" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "default" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = var.tags
}

locals {
  resource_group_name = var.create_resource_group ? azurerm_resource_group.default[0].name : data.azurerm_resource_group.default[0].name
}
#network module to be integrated in modules folder.
#subnet info to be integrated in module call.

resource "random_id" "default" {
  byte_length = 4
}


resource "azurerm_network_interface" "linux" {
  count               = var.create_linux_vm ? 1 : 0
  name                = "<name>-net-interface-linux-${random_id.default.hex}"
  location            = var.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = var.ip_configuration_private_ip_address_allocation
  }
}

resource "azurerm_network_interface" "windows" {
  count               = var.create_windows_vm ? 1 : 0
  name                = "<name>-net-interface-windows-${random_id.default.hex}"
  location            = var.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = var.ip_configuration_private_ip_address_allocation
  }
}

resource "random_password" "default" {
  length      = 72
  lower       = true
  numeric     = true
  special     = true
  upper       = true
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  min_upper   = 2
}

variable "keyvault_id" {

}

resource "azurerm_key_vault_secret" "vm_password" {
  key_vault_id = var.keyvault_id
  name         = replace("${lower(var.resource_group_name)}_${var.vm_name}_${var.login_admin_user}_user", "_", "-")
  value        = random_password.default.result
}

#### replaced "azurerm_virtual_machine" with the new resource "azurerm_linux_virtual_machine"

resource "azurerm_linux_virtual_machine" "linux" {
  count = var.create_linux_vm ? 1 : 0

  name                            = replace("${lower(var.resource_group_name)}-${var.vm_name}-${random_id.default.hex}", "_", "-") # add environment name
  location                        = var.location
  resource_group_name             = local.resource_group_name
  network_interface_ids           = [azurerm_network_interface.linux[0].id, ]
  size                            = var.vm_size
  disable_password_authentication = false

  tags = var.tags

  ## auth block ##
  admin_username = var.login_admin_user
  admin_password = random_password.default.result

  admin_ssh_key {
    username   = var.login_admin_user
    public_key = var.ssh_pub_key
  }

  ## /auth block ##

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.source_image_reference_linux_publisher
    offer     = var.source_image_reference_linux_offer
    sku       = var.source_image_reference_linux_sku
    version   = var.source_image_reference_linux_version
  }
}

# windows VM
resource "azurerm_windows_virtual_machine" "windows" {
  count = var.create_windows_vm ? 1 : 0

  name                  = "${lower(var.resource_group_name)}-${var.vm_name}-${random_id.default.hex}" # add environment name
  location              = var.location
  resource_group_name   = local.resource_group_name
  network_interface_ids = [azurerm_network_interface.windows[0].id, ]
  size                  = var.vm_size

  ## auth block ##
  admin_username = var.login_admin_user
  admin_password = random_password.default.result

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.source_image_reference_windows_publisher
    offer     = var.source_image_reference_windows_offer
    sku       = var.source_image_reference_windows_sku
    version   = var.source_image_reference_windows_version
  }
}