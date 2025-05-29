output "storage_account_id" {
  description = "id of the storage account"
  value       = azurerm_storage_account.default.id
}

output "storage_account_name" {
  description = "name of the storage account"
  value       = azurerm_storage_account.default.name
}
