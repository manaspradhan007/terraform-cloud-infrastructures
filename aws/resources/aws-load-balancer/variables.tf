##########
# Common #
##########
variable "prefix" {}

variable "environment" {}

variable "region" {}

variable "product" {}

######
# LB #
######
variable "create_external" {
  description = "If true (1) create external load balancer, if false (0) create internal load balancer"
}
variable "sku" {}

variable "availability_zone" {
  type = "list"
}

###########
# BACKEND #
###########

#############
# FRONT END #
#############

########
# RULE #
########

#######
# NAT #
#######

###########
# NETWORK #
###########

variable "vnet_name" {}

variable "subnet_name" {}

variable "subnet_name_list" {
  type = "list"
}
variable  "vnet_rg" {}
########
# TAGS #
########

variable "tags" {
  description = "A map of tags to be added to all resources."
  default     = {}
}
