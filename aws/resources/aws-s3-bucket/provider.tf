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