variable "region" {
}

variable "replication_region" {
  default     = "us-east-2"
}

variable "access_key" {
}

variable "secret_key" {
}

variable "token" {
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
  region     = var.region
}

provider "aws" {
  alias      = "replication"
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
  region     = var.replication_region
}