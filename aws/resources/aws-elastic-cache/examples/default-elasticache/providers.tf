###############
#  Variables  #
###############
variable "access_key" {
  description = "Access Key"
}

variable "secret_key" {
  description = "Secret Key"
}

variable "token" {
  description = "Token"
  default     = ""
}

variable "region" {
  description = "Region"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
  region     = var.region
}

