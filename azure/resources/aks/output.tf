output "cluster_id" {
  description = "id of kubernetes cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "vault_name" {
  value = azurerm_key_vault.this.name
}

output "vault_id" {
  value = azurerm_key_vault.this.id
}

output "akv_msi_principal_id" {
  value = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
}

output "name" {
  description = "AKS name"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "resource_group" {
  description = "Resource group in which AKS resides"
  value       = azurerm_kubernetes_cluster.aks.resource_group_name
}

output "location" {
  description = "Azure region in which AKS is deployed"
  value       = azurerm_kubernetes_cluster.aks.location
}

output "log_analytics_workspace_id" {
  description = "ID of log analytics workspace for log collection"
  value       = azurerm_log_analytics_workspace.analytics_workspace.id
}

output "cluster_oidc_issuer_url" {
  description = "ID of log analytics workspace for log collection"
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}
