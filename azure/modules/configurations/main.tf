
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rg.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rg.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

data "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = var.tags
}


module "k8s-configurations" {
  source = "../../sub-modules/kubernetes-resources/common-configurations"
  providers = {
    azurerm.hub = azurerm.hub
  }

  tags                     = var.tags
  environment-short        = var.environment-short
  environment_long         = var.environment_long
  cluster-users-group-name = var.user-group-all-azure-environmentname
  cluster-name             = var.cluster-name
  resource-group-name      = var.resource_group_name
  resource-group-name-hub  = var.resource-group-name-hub
  private-dns-entries = {
    #"trace.monitoring.staging" = "10.100.1.0"
  }
  public-dns-entries = {
    #"trace.monitoring.staging" = "51.145.177.53"
  }

  # kubernetes global resources
  global-resources-gitlab-access-token-value = var.global-resources-gitlab-access-token-value

  # cert-manager
  cert-manager-version                     = var.cert_manager_version
  aerenacom-certificates                   = true
  ifeswcom-certificates                    = true
  cluster-issuer-gitlab-access-token-value = var.cluster-issuer-gitlab-access-token-value
  aerenacom-dns-zone-manager-appID         = var.aerenacom-dns-zone-manager-appID
  aerenacom-dns-zone-manager-secret        = var.aerenacom-dns-zone-manager-secret
  ifeswcom-dns-zone-manager-appID          = var.ifeswcom-dns-zone-manager-appID
  ifeswcom-dns-zone-manager-secret         = var.ifeswcom-dns-zone-manager-secret
  # nginx-ingress-controller
  ingress_version                     = var.ingress_version
  ingress_package_registry_password   = var.ingress_package_registry_password
  nginx_ingress_controller_private_ip = nginx_ingress_controller_private_ip
  # smtp-server
  smtp-server-allowed-domain = "ifesw.com"
  key_vault_name             = var.key_vault_name
}