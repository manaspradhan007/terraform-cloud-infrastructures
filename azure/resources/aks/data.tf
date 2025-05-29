data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "cluster_monitor_categories" {
  resource_id = azurerm_kubernetes_cluster.aks.id
}

data "azuread_group" "devops_admins" {
  display_name     = "DevOps-Admins"
  security_enabled = true
}