##########################################
# Providers Set as Environment Variables #
##########################################

##########
# Common #
##########
region = "eastus2"
prefix = "tenm"
environment = "dev"
product = "al"

##############
# Networking #
##############
vnet_name = "tenm-dev-al-vnet"
subnet_name = "tenm-dev-private-01"
subnet_name_list = ["tenm-dev-private-01"]

######
# LB #
######
create_external = 1
sku = "Standard"
availability_zone = ["1"]

########
# Tags #
########
tags = {
    "TenantCode" = "D1GS01"
    "0050:InfraMgmt" = "Skynet"
    "Environemnt"   = "dev"
}