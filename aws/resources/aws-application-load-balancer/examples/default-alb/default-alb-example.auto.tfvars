#############
# Providers #
#############
####################
# Default Provider #
####################
region              = "<insert region here>"
access_key          = "<insert access_key here>"
secret_key          = "<insert secret_key here>"
token               = "<insert token here>"

#####################
# Route 53 Provider #
#####################
route53_region      = "<insert route53 region here>"
route53_access_key  = "<insert route53 access_key here>"
route53_secret_key  = "<insert route53 secret_key here>"
route53_token       = "<insert route53 token here>"

#######
# ALB #
#######
default_alb_example_resource_name_prefix = "D1AM00-AL-API-PVT-INT"
default_alb_example_vpc_id               = "vpc-0f0281977bd68aa7d"
default_alb_example_subnet_ids           = ["subnet-08555144b928ab2ff", "subnet-025da2ef6528e96f9"]
default_alb_example_route53_zone_id      = "Z37WTU5PO9M6J4"
default_alb_example_route53_record_name  = "d1am00-api-pvt-int.lowerenv.com"
default_alb_example_tags                 = {"TenantCode" = "D1AM00", "UserName" = "AMOYEEN", "0050:InfraMgmt" = ""}