output "storage-account-object" {
  description = "Returns the Azure Storage Account object"
  value       = azurerm_storage_account.storage-account
  sensitive   = true
}

output "id" {
  description = "Returns the ID of the storage account"
  value       = azurerm_storage_account.storage-account.id
}

output "name" {
  description = "Returns the name of the storage account"
  value       = azurerm_storage_account.storage-account.name
}
