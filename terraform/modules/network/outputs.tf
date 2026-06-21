output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "vnet_name" {
  value = azurerm_virtual_network.this.name
}

output "apim_subnet_id" {
  value = azurerm_subnet.apim.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "private_endpoint_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}
