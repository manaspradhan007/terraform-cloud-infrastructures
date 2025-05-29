variable "create_resource_group" {
  type    = bool
  default = false
}

variable "resource_group_name" {
  type    = string
  default = "<some-name-here>-prod-rg"
}

variable "key_vault_name" {
  type = string
}

variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
  default = {
    created-by = "DevOps-Admins-Terraformed"
  }
}

variable "environment-short" {
  type    = string
  default = "prod"
}

variable "environment_long" {
  type    = string
  default = "production"
}

variable "location" {
  type    = string
  default = "west europe"
}

variable "resource-group-name-hub" {
  type    = string
  default = "<some-name-here>-network-rg"
}

variable "network-name-hub" {
  type    = string
  default = "<some-name-here>-network"
}

variable "cluster-name" {
  type    = string
  default = "production-cluster"
}

variable "devops-storage-account-name" {
  type    = string
  default = "<some-name-here>devops"
}

variable "devops-storage-blob-private-endpoint-name" {
  type    = string
  default = "<some-name-here>devopsblob"
}

variable "vault-name" {
  type    = string
  default = "<some-name-here>devops"
}

variable "vault-private-endpoint-name" {
  type    = string
  default = "<some-name-here>devops-vault"
}

variable "user-group-all-azure-environmentname" {
  type    = string
  default = "all-azure-production"
}
variable "resource-group-name-environmentname" {
  type    = string
  default = ""
}

variable "cluster-issuer-gitlab-access-token-value" {
  type = string
}

variable "ifeswcom-dns-zone-manager-secret" {
  type = string
}

variable "ifeswcom-dns-zone-manager-appID" {
  type = string
}

variable "aerenacom-dns-zone-manager-secret" {
  type = string
}

variable "aerenacom-dns-zone-manager-appID" {
  type = string
}

variable "jaeger-gitlab-access-token-value" {
  type = string
}

variable "global-resources-gitlab-access-token-value" {
  type = string
}
variable "package_registry_password" {
  type = string
}

variable "cert_manager_version" {
  type = string
}
variable "ingress_version" {
  type = string
}


