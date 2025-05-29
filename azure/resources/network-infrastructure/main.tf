terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [azurerm.hub]
    }
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = var.tags
  lifecycle {
    ignore_changes = [
      resource_group_name
    ]
  }
}

################################################################################
# subnets
################################################################################

resource "azurerm_subnet" "subnets" {
  for_each = {
    for subnet in var.subnet_names :
    subnet.name => subnet.address_space
  }
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = each.key
  address_prefixes     = [each.value]
  lifecycle {
    ignore_changes = [
      resource_group_name
    ]
  }
}

################################################################################
# peering
################################################################################

resource "azurerm_virtual_network_peering" "peering_hub2env" {
  provider                  = azurerm.hub
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_network_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  name                      = format("%s-%s-%s", "hub", var.environment_short, "link")
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

resource "azurerm_virtual_network_peering" "peering-env2hub" {
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = var.hub_network_id
  name                      = format("%s-%s-%s", var.environment_short, "hub", "link")
  allow_forwarded_traffic   = true
  use_remote_gateways       = true
}