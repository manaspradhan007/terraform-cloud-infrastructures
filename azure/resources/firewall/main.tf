locals {
  tenant_id           = "<tenant-id>"
  hub_id              = "<subscription-id>"
  resource_group_name = element(coalescelist(data.azurerm_resource_group.firewall_rg.*.name, azurerm_resource_group.firewall_rg.*.name, [""]), 0)
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.39.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.23.0"
    }
  }
  backend "azurerm" {
    tenant_id            = "<tenant-id>"
    subscription_id      = "<subscription-id>"
    resource_group_name  = "devops-terra-rg"
    storage_account_name = "<statefileaccountname-tfstate>"
    container_name       = "tfstate"
    key                  = "tesstfirewall.terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  alias           = "hub"
  tenant_id       = local.tenant_id
  subscription_id = local.hub_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "firewall_rg" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "firewall_rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = var.tags
}

############################
# data
############################

data "azurerm_subnet" "hub_firewall_subnet" {
  count                = var.deploy_in_hub ? 1 : 0
  provider             = azurerm.hub
  name                 = "AzureFirewallSubnet"
  virtual_network_name = var.hub_network_name
  resource_group_name  = var.hub_network_rg
}

module "firewall_network" {
  providers = {
    azurerm.hub = azurerm.hub
  }
  depends_on = [
    azurerm_resource_group.firewall_rg
  ]
  count                       = var.create_new_network ? 1 : 0
  source                      = "../../../sub-modules/azure-resources/network-infrastructure"
  hub_resource_group_name     = var.firewall_hub_resource_group_name
  hub_network_name            = var.firewall_hub_network_name
  location                    = var.location
  create_resource_group       = false
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.firewall_network_security_group_name
  virtual_network_name        = var.firewall_virtual_network_name
  address_space               = var.firewall_address_space
  subnet_names                = var.firewall_subnet_names
  hub_to_env_link_name        = var.firewall_hub_to_env_link_name
  env_to_hub_link_name        = var.firewall_env_to_hub_link_name
  hub_network_id              = var.hub_network_id
  tags                        = var.tags
}

resource "azurerm_subnet" "firewall_subnet" {
  depends_on = [
    module.firewall_network
  ]
  count                = var.deploy_in_hub ? 0 : 1
  resource_group_name  = var.resource_group_name
  name                 = "AzureFirewallSubnet"
  virtual_network_name = var.firewall_virtual_network_name
  address_prefixes     = var.firewall_subnet_address_prefix
}

################################################################################
# firewall
################################################################################

resource "azurerm_public_ip" "firewall_pip" {
  depends_on = [
    azurerm_resource_group.firewall_rg,
    module.firewall_network
  ]
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  name                = format("%s-%s", var.firewall_env, "firewall-public-ip")
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "<name>-mail-prod"
  #reverse_fqdn        = "ifesw.com."
  sku_tier = "Regional"
  zones    = ["1", "2", "3"]
}

# DNS settings have to done manually however! (DNS Proxy enabled --> Default/Azure-provided DNS Server)
resource "azurerm_firewall" "firewall" {
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  name                = format("%s-%s", var.firewall_env, "Firewall")
  zones               = ["1", "2", "3"]
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet"
  ip_configuration {
    name                 = format("%s-%s", lower(var.firewall_env), "firewall-public-ip")
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
    subnet_id            = var.deploy_in_hub ? data.azurerm_subnet.hub_firewall_subnet[0].id : azurerm_subnet.firewall_subnet[0].id
  }

  lifecycle {
    ignore_changes = [
      ip_configuration
    ]
  }
}
