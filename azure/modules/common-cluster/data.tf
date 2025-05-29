data "terraform_remote_state" "global" {
  backend = "azurerm"
  config = {
    tenant_id            = var.tenant_id
    subscription_id      = var.subscription_id
    key                  = "terraform.tfstate"
    resource_group_name  = "devops-terra-rg"
    storage_account_name = "<some-name-here>tfstate"
    container_name       = "tfstate"
    use_azuread_auth     = true
  }
}

data "terraform_remote_state" "init" {
  backend = "azurerm"
  config = {
    tenant_id            = var.tenant_id
    subscription_id      = var.subscription_id
    key                  = "init/terraform.tfstate"
    resource_group_name  = "devops-terra-rg"
    storage_account_name = "<some-name-here>tfstate"
    container_name       = "tfstate"
    use_azuread_auth     = true
  }
}
