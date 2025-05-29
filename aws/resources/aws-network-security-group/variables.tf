##########
# Common #
##########
variable "prefix" {}

variable "environment" {}

variable "region" {}

variable "product" {}


########
# TAGS #
########

variable "tags" {
  description = "A map of tags to be added to all resources."
  default     = {}
}
