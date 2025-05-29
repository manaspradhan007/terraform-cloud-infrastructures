##########
# Common #
##########
variable "prefix" {}

variable "environment" {}

variable "region" {}

variable "product" {}

#######
# ILB #
#######
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
variable "create_external" {
  description = "If true (1) create external load balancer, if false (0) create internal load balancer"
}

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

########
# TAGS #
########

variable "tags" {
  description = "A map of tags to be added to all resources."
  default     = {}
}
