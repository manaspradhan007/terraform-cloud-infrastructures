variable "region" {
}

variable "access_key" {
}

variable "secret_key" {
}

variable "token" {
}

provider "aws" {
  version    = "2.70.0"
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
}

###################
# Master Provider #
###################
variable "master_region" {
}

variable "master_access_key" {
}

variable "master_secret_key" {
}

variable "master_token" {
}
provider "aws" {
  alias      = "master"
  region     = var.master_region
  access_key = var.master_access_key
  secret_key = var.master_secret_key
  token      = var.master_token
}