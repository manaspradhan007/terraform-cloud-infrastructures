#############
# Providers #
#############
####################
# Default Provider #
####################
region              = "<>"
access_key          = "<>"
secret_key          = "<>"
token               = "<>"

#####################
# Route 53 Provider #
#####################
route53_region      = "<>"
route53_access_key  = "<>"
route53_secret_key  = "<>"
route53_token       = "<>"


#######
# NLB #
#######
default_nlb_example_resource_name_prefix = "D1IPV1-TEST-NLB"
default_nlb_example_vpc_id               = "vpc-0b5b83654b21c079c"
default_nlb_example_subnet_ids           = ["subnet-037a9a3d2249b596a", "subnet-0a74a146e1e37a0b1"]
default_nlb_example_route53_zone_id      = "Z37WTU5PO9M6J4"
default_nlb_example_route53_record_name  = "d1ipv1-test-nlb.lowerenv.com"
default_nlb_example_tags                 = {"TenantCode" = "D1IPV1", "UserName" = "InspecPipelineVerification", "0050:InfraMgmt" = ""}