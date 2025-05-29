terraform {
  required_providers {
    stackit = {
      source  = "stackitcloud/stackit"
      version = "0.43.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
