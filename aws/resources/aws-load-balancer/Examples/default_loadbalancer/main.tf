module "azurerm-loadbalancer" {
  source = "../../"

  prefix            = "${var.prefix}"
  environment       = "${var.environment}"
  region            = "${var.region}"
  product           = "${var.product}"
  tags              = "${var.tags}"
  vnet_name         = "${var.vnet_name}"
  create_external   = "${var.create_external}"
  subnet_name       = "${var.subnet_name}"
  subnet_name_list  = "${var.subnet_name_list}"
  sku               = "${var.sku}"
  availability_zone = "${var.availability_zone}"
}
