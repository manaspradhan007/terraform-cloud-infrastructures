locals {
  #Bad Subnet is a placeholder for an error code in the postfix check
  bad_subnet                     = "subnet error"
  subnet_validation              = "${contains(var.subnet_name_list, var.subnet_name)}"
  frontend_ip_configuration_name = "${var.prefix}-${var.environment}-${var.product}-pip"
  lb_name                       = "${var.prefix}-${var.environment}-${var.product}-lb"
}

resource "azurerm_resource_group" "loadbalancer_rg" {
  name     = "${var.prefix}-${var.environment}-${var.product}-lb-rg"
  location = "${var.region}"

  tags = "${merge(map("Name", format("%s-%s", var.prefix, "rg")), var.tags)}"
}

data "azurerm_subnet" "vm_subnet" {
  name                 = "${local.subnet_validation == true ? var.subnet_name : local.bad_subnet}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.vnet_rg}"
  #resource_group_name  = "${var.prefix}-${var.environment}-${var.product}-networking-rg"
}

###################################
# External Load Balancer Resource #
###################################

resource "azurerm_public_ip" "lb_public_ip" {
  count = "${var.create_external == 1 ? 1 : 0 }"

  name                         = "${local.lb_name}-pip"
  location                     = "${azurerm_resource_group.loadbalancer_rg.location}"
  resource_group_name          = "${azurerm_resource_group.loadbalancer_rg.name}"
  domain_name_label            = "${local.lb_name}"
  sku                          = "${var.sku}"
  allocation_method            = "Static"
  zones                        = ["${var.availability_zone}"]

  tags = "${merge(map("Name", format("%s-%s", var.prefix, "pip")), var.tags)}"
}


resource "azurerm_lb" "elb" {
  count = "${var.create_external == 1 ? 1 : 0}"

  name                = "${local.lb_name}"
  location            = "${azurerm_resource_group.loadbalancer_rg.location}"
  resource_group_name = "${azurerm_resource_group.loadbalancer_rg.name}"
  tags                = "${merge(map("Name", format("%s-%s", var.prefix, "ilb")), var.tags)}"
  sku                 = "${var.sku}"

  frontend_ip_configuration {
    name                          = "${local.frontend_ip_configuration_name}"
    public_ip_address_id          = "${azurerm_public_ip.lb_public_ip.id}"
  }
}
resource "azurerm_lb_backend_address_pool" "elb_be_pool" {
  count = "${var.create_external == 1 ? 1 : 0}"

  resource_group_name = "${azurerm_resource_group.loadbalancer_rg.name}"
  loadbalancer_id     = "${azurerm_lb.elb.id}"
  name                = "${var.prefix}-${var.environment}-${var.product}-web-pool"
}
resource "azurerm_lb_probe" "elb_http_probe" {
  count = "${var.create_external == 1 ? 1 : 0}"

  resource_group_name = "${azurerm_resource_group.loadbalancer_rg.name}"
  loadbalancer_id     = "${azurerm_lb.elb.id}"
  name                = "http-isrunning-probe"
  port                = 80
}
resource "azurerm_lb_probe" "elb_https_probe" {
  count = "${var.create_external == 1 ? 1 : 0}"

  resource_group_name = "${azurerm_resource_group.loadbalancer_rg.name}"
  loadbalancer_id     = "${azurerm_lb.elb.id}"
  name                = "https-isrunning-probe"
  port                = 443
}

resource "azurerm_lb_rule" "elb_http_rule" {
  count = "${var.create_external == 1 ? 1 : 0}"

  resource_group_name            = "${azurerm_resource_group.loadbalancer_rg.name}"
  loadbalancer_id                = "${azurerm_lb.elb.id}"
  name                           = "http-loadbalancing-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
}
resource "azurerm_lb_rule" "elb_https_rule" {
  count = "${var.create_external == 1 ? 1 : 0}"

  resource_group_name            = "${azurerm_resource_group.loadbalancer_rg.name}"
  loadbalancer_id                = "${azurerm_lb.elb.id}"
  name                           = "https-loadbalancing-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
}

###################################
# Internal Load Balancer Resource #
###################################

resource "azurerm_lb" "ilb" {
  count = "${var.create_external == 0 ? 1 : 0}"

  name                = "${local.lb_name}"
  location            = "${azurerm_resource_group.loadbalancer_rg.location}"
  resource_group_name = "${azurerm_resource_group.loadbalancer_rg.name}"
  tags                = "${merge(map("Name", format("%s-%s", var.prefix, "ilb")), var.tags)}"
  sku                 = "${var.sku}"

  frontend_ip_configuration {
    name                          = "${local.frontend_ip_configuration_name}"
    subnet_id                     = "${data.azurerm_subnet.vm_subnet.id}"
    private_ip_address_allocation = "Dynamic"
    zones                         = ["${var.availability_zone}"]
  }
}
resource "azurerm_lb_backend_address_pool" "ilb_be_pool" {
  count = "${var.create_external == 0 ? 1 : 0}"

  resource_group_name = "${azurerm_resource_group.loadbalancer_rg.name}"
  loadbalancer_id     = "${azurerm_lb.ilb.id}"
  name                = "${var.prefix}-${var.environment}-${var.product}-web-pool"
}

resource "azurerm_lb_probe" "ilb_http_probe" {
  count = "${var.create_external == 0 ? 1 : 0}"

  resource_group_name = "${azurerm_resource_group.loadbalancer_rg.name}"
  loadbalancer_id     = "${azurerm_lb.ilb.id}"
  name                = "http-isrunning-probe"
  port                = 80
}
resource "azurerm_lb_probe" "ilb_https_probe" {
  count = "${var.create_external == 0 ? 1 : 0}"

  resource_group_name = "${azurerm_resource_group.loadbalancer_rg.name}"
  loadbalancer_id     = "${azurerm_lb.ilb.id}"
  name                = "https-isrunning-probe"
  port                = 443
}

resource "azurerm_lb_rule" "ilb_http_rule" {
  count = "${var.create_external == 0 ? 1 : 0}"

  resource_group_name            = "${azurerm_resource_group.loadbalancer_rg.name}"
  loadbalancer_id                = "${azurerm_lb.ilb.id}"
  name                           = "http-loadbalancing-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
}

resource "azurerm_lb_rule" "ilb_https_rule" {
  count = "${var.create_external == 0 ? 1 : 0}"

  resource_group_name            = "${azurerm_resource_group.loadbalancer_rg.name}"
  loadbalancer_id                = "${azurerm_lb.ilb.id}"
  name                           = "https-loadbalancing-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
}