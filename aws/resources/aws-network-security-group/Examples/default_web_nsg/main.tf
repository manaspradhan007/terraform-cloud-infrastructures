module "azurerm-web-nsg" {
  source = "../../"
  
  prefix            = "${var.prefix}"
  environment       = "${var.environment}"
  region            = "${var.region}"
  product           = "${var.product}"
  tags              = "${var.tags}"
}
