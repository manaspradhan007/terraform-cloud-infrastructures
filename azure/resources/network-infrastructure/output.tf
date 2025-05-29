output "virtual_network_id" {
  description = "id of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "virtual_network_name" {
  description = "name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnets" {
  description = "subnet/subnets output for the vnet created"
  value       = azurerm_subnet.subnets
}

output "virtual_network_address_space" {
  value = azurerm_virtual_network.vnet.address_space
}

