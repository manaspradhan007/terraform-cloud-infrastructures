module "default_nlb_example" {
  source = "../../"

  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
  region     = var.region

  route53_access_key = var.route53_access_key
  route53_secret_key = var.route53_secret_key
  route53_token      = var.route53_token
  route53_region     = var.route53_region

  resource_name_prefix = var.default_nlb_example_resource_name_prefix
  vpc_id               = var.default_nlb_example_vpc_id
  subnet_ids           = var.default_nlb_example_subnet_ids
  route53_zone_id      = var.default_nlb_example_route53_zone_id
  route53_record_name  = var.default_nlb_example_route53_record_name
  tags                 = var.default_nlb_example_tags
}

