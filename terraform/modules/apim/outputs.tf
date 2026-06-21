output "id" {
  value = azurerm_api_management.this.id
}

output "name" {
  value = azurerm_api_management.this.name
}

output "principal_id" {
  value = azurerm_api_management.this.identity[0].principal_id
}
