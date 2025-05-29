locals {
  private_dns_zones = [
    "privatelink.mongo.cosmos.azure.com",
    "privatelink.mysql.database.azure.com",
    "privatelink.postgres.database.azure.com",
    "privatelink.redis.cache.windows.net",
    "privatelink.blob.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.file.core.windows.net",
    "privatelink.westeurope.azmk8s.io",
    "privatelink.grafana.azure.com",
    "privatelink.dfs.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.westeurope.prometheus.monitor.azure.com",
  ]
  public_endpoints = flatten([
    for endpoint_list in values(var.public_endpoints_severity_map) :
    endpoint_list
  ])
  private_endpoints = flatten([
    for endpoint_list in values(var.private_endpoints_severity_map) :
    endpoint_list
  ])
  aks_monitoring_parameters = {
    name           = module.aks_cluster.name
    resource_group = module.aks_cluster.resource_group
    location       = module.aks_cluster.location
  }
}

resource "azurerm_resource_group" "rg" {
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = var.tags
  lifecycle {
    ignore_changes = [
      name
    ]
  }
}

##################################################
# Network Module
##################################################

module "network" {
  providers = {
    azurerm.hub = azurerm.hub
  }
  source                  = "../../sub-modules/azure-resources/network-infrastructure"
  environment_short       = var.environment_short
  hub_resource_group_name = local.resource_group_name_hub
  hub_network_name        = local.virtual_network_name
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  virtual_network_name    = var.virtual_network_name
  address_space           = var.address_space
  subnet_names            = var.subnet_names
  hub_network_id          = local.virtual_network_id
  tags                    = var.tags
}

#################################################
# Route Table association
#################################################

resource "azurerm_route_table" "route_table" {
  name                = format("%s-%s", var.environment_long, "routetable")
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.firewall_private_ip
  }
}

resource "azurerm_subnet_route_table_association" "route_table_assn" {
  subnet_id      = module.network.subnets[var.subnet_names[0].name].id
  route_table_id = azurerm_route_table.route_table.id
}

# ##################################################
# # Storage Module
# ##################################################

module "storage" {
  source                        = "../../sub-modules/azure-resources/storageaccount"
  teamname                      = var.teamname
  environment_short             = var.environment_short
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = var.location
  storage_account_name          = var.storage_account_name
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  storageaccount_subnet_address = [var.storageaccount_subnet_address]
  private_dns_zone_id           = var.privatelinkblob_dnszone_id
  virtual_network_name          = module.network.virtual_network_name
  subnet_id                     = module.network.subnets[var.subnet_names[0].name].id
  tags                          = var.tags
}

# ##################################################
# # AKS Cluster Module
# ##################################################

module "aks_cluster" {
  providers = {
    azurerm.hub = azurerm.hub
  }
  source                                  = "../../sub-modules/azure-resources/aks"
  create_azure_monitor_extended_resources = true
  tags                                    = var.tags
  environment_short                       = var.environment_short
  environment_long                        = var.environment_long
  tenant_id                               = var.tenant_id
  cluster_name                            = format("%s-cluster", var.environment_long)
  vault_name                              = var.akv_name
  kubernetes_version                      = var.kubernetes_version
  resource_group_name                     = azurerm_resource_group.rg.name
  resource_group_name_hub                 = local.resource_group_name_hub
  kubernetes_vnet_name                    = module.network.virtual_network_name
  kubernetes_vnet_id                      = module.network.virtual_network_id
  subnet_name                             = module.network.subnets[var.subnet_names[0].name].name
  location                                = var.location
  storage_account_id                      = module.storage.storage_account_id
  private_dns_zone_id                     = var.privatelinkaks_dnszone_id
  subnet_id                               = module.network.subnets[var.subnet_names[0].name].id
  analytics_workspace_daily_quota         = var.analytics_workspace_daily_quota
}

###########################################
# IP Group
###########################################
resource "azurerm_ip_group" "cluster-vnet-ip-group" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = format("%s-%s", var.environment_long, "cluster")
  cidrs               = module.network.virtual_network_address_space
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      resource_group_name
    ]
  }
}

########################################
# Kubernetes Configurations
########################################

module "k8s-configurations" {
  source = "../../sub-modules/kubernetes-resources/common-configurations"
  providers = {
    azurerm.hub = azurerm.hub
  }
  tags                     = var.tags
  environment_long         = var.environment_long
  resource_group_id        = azurerm_resource_group.rg.id
  cluster_users_group_name = var.user_group_all_azure_environmentname
  aks_id                   = module.aks_cluster.cluster_id
  akv = {
    id               = module.aks_cluster.vault_id
    msi_principal_id = module.aks_cluster.akv_msi_principal_id
  }
  resource_group_name_hub = local.resource_group_name_hub
  private_dns_entries = {
    #"trace.monitoring.staging" = "10.100.1.0"
  }
  public_dns_entries = {
    #"trace.monitoring.staging" = "51.145.177.53"
  }
  # kubernetes global resources
  global_resources_gitlab_access_token_value = var.global_resources_gitlab_access_token_value
  # cert-manager
  cert_manager_version                     = var.cert_manager_version
  ingress_version                          = var.ingress_version
  ingress_package_registry_password        = var.ingress_package_registry_password
  aerenacom_certificates                   = true
  ifeswcom_certificates                    = true
  cluster_issuer_gitlab_access_token_value = var.cluster_issuer_gitlab_access_token_value
  aerenacom_dns_zone_manager_appID         = var.aerenacom_dns_zone_manager_appID
  aerenacom_dns_zone_manager_secret        = var.aerenacom_dns_zone_manager_secret
  ifeswcom_dns_zone_manager_appID          = var.ifeswcom_dns_zone_manager_appID
  ifeswcom_dns_zone_manager_secret         = var.ifeswcom_dns_zone_manager_secret
  nginx_ingress_controller_private_ip      = var.nginx_ingress_ip
  smtp_server_allowed_domain               = "ifesw.com"
  kubernetes_global_resources_version      = var.kubernetes_global_resources_version
}

###########################################
# Prometheus data collection module
###########################################
module "prometheus_data_collection" {
  providers = {
    azurerm.hub = azurerm.hub
  }
  source                    = "../../sub-modules/azure-resources/prometheus-data-collection"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = var.location
  target_aks_id             = module.aks_cluster.cluster_id
  cluster_name              = module.aks_cluster.name
  monitor_account_name      = var.monitor_account_name
  monitor_workspace_id      = local.prometheus_workspace_id
  prometheus_forwarder_name = var.prometheus_forwarder_name
  streams                   = var.streams
}


################################################################################
# privatelink dns zone links to vnet
################################################################################
data "azurerm_private_dns_zone" "privatelink_dns_zones" {
  for_each = { for zone in local.private_dns_zones : zone => zone }

  name                = each.value
  resource_group_name = local.resource_group_name_hub
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link_dns_zone" {
  for_each = { for zone in local.private_dns_zones : zone => zone }

  name                  = format("%s-${each.value}", var.environment_long)
  resource_group_name   = local.resource_group_name_hub
  private_dns_zone_name = each.value
  virtual_network_id    = module.network.virtual_network_id
}
