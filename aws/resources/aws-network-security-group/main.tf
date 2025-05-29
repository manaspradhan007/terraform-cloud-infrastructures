resource "azurerm_resource_group" "nsg_rg" {
  name     = "${var.prefix}-${var.environment}-${var.product}-nsg-rg"
  location = "${var.region}"

  tags = "${merge(map("Name", format("%s-%s", var.prefix, "rg")), var.tags)}"
}

resource "azurerm_network_security_group" "al_nsg_allow_http_https" {
  name                = "${var.prefix}-${var.environment}-${var.product}-web-nsg"
  location            = "${azurerm_resource_group.nsg_rg.location}"
  resource_group_name = "${azurerm_resource_group.nsg_rg.name}"

  tags = "${merge(map("Name", format("%s-%s", var.prefix, "nsg")), var.tags)}"
}
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "al_allow_http_inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.nsg_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.al_nsg_allow_http_https.name}"
}
resource "azurerm_network_security_rule" "allow_https" {
  name                        = "al_allow_https_inbound"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "443"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.nsg_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.al_nsg_allow_http_https.name}"
}
resource "azurerm_network_security_rule" "allow_outbound" {
  name                        = "al_allow_all_outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.nsg_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.al_nsg_allow_http_https.name}"
}

