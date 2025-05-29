################################################################################
# Locals
################################################################################
terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [azurerm.hub]
    }
  }
}

################################################################################
# azure ad group
################################################################################

resource "azuread_group" "cluster_admins" {
  display_name     = format("%s-cluster-admins", var.environment_short)
  security_enabled = true
}

resource "azuread_group_member" "devops_cluster_admin" {
  member_object_id = data.azuread_group.devops_admins.object_id
  group_object_id  = azuread_group.cluster_admins.object_id
}

################################################################################
# identity
################################################################################

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "kubernetes_managed_identity"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      resource_group_name
    ]
  }
}

resource "azurerm_role_assignment" "private_dns_contributor" {
  scope                = var.private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.kubernetes_vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

################################################################################
# log analytics workspace
################################################################################

resource "azurerm_log_analytics_workspace" "analytics_workspace" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-k8s-cluster-logs", var.environment_short)
  tags                = var.tags
  daily_quota_gb      = var.analytics_workspace_daily_quota
  retention_in_days   = var.analytics_workspace_retention_days
  sku                 = var.analytics_workspace_sku
}

resource "azurerm_monitor_diagnostic_setting" "cluster_logs_archive" {
  count              = var.create_azure_monitor_extended_resources ? 1 : 0
  name               = format("%s-cluster-logs-archive", var.environment_short)
  target_resource_id = azurerm_kubernetes_cluster.aks.id
  storage_account_id = var.storage_account_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.cluster_monitor_categories.log_category_types
    content {
      category = log.value
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false
  }

  lifecycle {
    ignore_changes = [
      log
    ]
  }
}

################################################################################
# cluster
################################################################################

resource "azurerm_kubernetes_cluster" "aks" {
  resource_group_name               = var.resource_group_name
  location                          = var.location
  name                              = var.cluster_name
  dns_prefix_private_cluster        = var.cluster_name
  private_cluster_enabled           = true
  tags                              = var.tags
  private_dns_zone_id               = var.private_dns_zone_id
  role_based_access_control_enabled = true
  local_account_disabled            = true
  image_cleaner_enabled             = false
  kubernetes_version                = var.kubernetes_version
  oidc_issuer_enabled               = var.oidc_issuer_enabled

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [azuread_group.cluster_admins.id]
    azure_rbac_enabled     = true
  }

  default_node_pool {
    name                         = var.system_nodepool_name
    only_critical_addons_enabled = true
    vm_size                      = var.system_nodepool_node_tier # min is 2vCPUs and 4GB memory
    type                         = "VirtualMachineScaleSets"
    tags                         = var.tags
    enable_auto_scaling          = true
    min_count                    = var.system_nodepool_node_min_count
    max_count                    = var.system_nodepool_node_max_count
    vnet_subnet_id               = var.subnet_id
    upgrade_settings {
      max_surge = "33%" # recommended by Azure for production grade use https://learn.microsoft.com/en-us/azure/aks/upgrade-cluster#optimize-upgrades-to-improve-performance-and-minimize-disruptions
    }
  }

  open_service_mesh_enabled = true
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_workspace.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  # This add_on cannot be deployed by terraform because the aci service_principal needs the "Contributor" role
  # on the Vnet scope. To enable aci after deployment follow https://docs.microsoft.com/en_us/azure/aks/virtual_nodes_cli
  # aci_connector_linux {
  #   subnet_name = azurerm_subnet.aci_subnet.name
  # }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    outbound_type  = "userDefinedRouting"
  }

  storage_profile {
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }

  # consolidation requirement
  lifecycle {
    ignore_changes = [
      default_node_pool.0.vnet_subnet_id,
      resource_group_name,
      linux_profile,
      storage_profile,
      private_dns_zone_id,
      image_cleaner_enabled,
      image_cleaner_interval_hours
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks.id
  name                   = var.user_nodepool1_name
  vm_size                = var.user_nodepool1_node_tier
  mode                   = "User"
  vnet_subnet_id         = var.subnet_id
  os_disk_type           = "Managed"
  zones                  = []
  enable_auto_scaling    = true
  enable_host_encryption = false
  enable_node_public_ip  = false
  fips_enabled           = false
  min_count              = var.user_nodepool1_node_min_count
  max_count              = var.user_nodepool1_node_max_count
  tags                   = var.tags

  # consolidation requirement
  lifecycle {
    ignore_changes = [
      vnet_subnet_id, kubernetes_cluster_id
    ]
  }
}

################################################################################
# Key Vault
################################################################################

resource "azurerm_key_vault" "this" {

  name                          = var.vault_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = var.tenant_id
  purge_protection_enabled      = var.vault_purge_protection_enabled
  public_network_access_enabled = false
  soft_delete_retention_days    = var.vault_soft_delete_retention_days
  sku_name                      = var.vault_sku
  enable_rbac_authorization     = true
  tags                          = var.tags
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

module "privatelink" {
  source = "../privatelink"
  providers = {
    azurerm.hub = azurerm.hub
  }
  env                     = var.environment_short
  tags                    = var.tags
  project                 = "k8s"
  location                = var.location
  resource_group_name     = var.resource_group_name
  resource_group_name_hub = var.resource_group_name_hub
  virtual_network_name    = var.kubernetes_vnet_name

  name                    = "example-key-vault"
  linktype                = "vault"
  resource_id             = azurerm_key_vault.this.id
  subresource_names       = ["vault"]
  subnet_id               = var.subnet_id
  privatelink_subnet_name = var.subnet_name
}

resource "azurerm_eventgrid_system_topic" "vault_system_topic" {
  name                   = format("key-%s-vault", var.environment_long)
  resource_group_name    = var.resource_group_name
  location               = var.location
  source_arm_resource_id = azurerm_key_vault.this.id
  topic_type             = "Microsoft.KeyVault.vaults"
}


resource "azurerm_role_assignment" "vault_administrator_devops_admin" {
  principal_id         = data.azuread_group.devops_admins.object_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
}
