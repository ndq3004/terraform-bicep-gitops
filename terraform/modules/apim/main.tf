resource "azurerm_api_management" "this" {
  name                 = var.apim_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  sku_name             = var.sku_name
  virtual_network_type = var.virtual_network_type
  identity {
    type = "SystemAssigned"
  }

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }
}

resource "azurerm_api_management_backend" "aks" {
  name                = "aks-backend"
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  protocol            = var.backend_protocol
  url                 = var.backend_url
}

resource "azurerm_api_management_api" "backend" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.this.name
  revision            = "1"
  display_name        = var.api_display_name
  path                = var.api_path
  protocols           = ["https"]
  service_url         = var.backend_url
}
