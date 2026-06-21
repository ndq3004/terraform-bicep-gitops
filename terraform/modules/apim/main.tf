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

locals {
  use_openapi_import         = var.api_openapi_spec_content != null && trimspace(var.api_openapi_spec_content) != ""
  create_fallback_operations = !local.use_openapi_import && var.enable_fallback_operations
  fallback_methods           = toset(["GET", "POST", "PUT", "DELETE", "PATCH"])
}

resource "azurerm_api_management_api" "backend" {
  name                  = var.api_name
  resource_group_name   = var.resource_group_name
  api_management_name   = azurerm_api_management.this.name
  revision              = "1"
  display_name          = var.api_display_name
  path                  = var.api_path
  protocols             = ["https"]
  service_url           = var.backend_url
  subscription_required = var.api_subscription_required

  dynamic "import" {
    for_each = local.use_openapi_import ? [1] : []
    content {
      content_format = var.api_openapi_spec_format
      content_value  = var.api_openapi_spec_content
    }
  }
}

resource "azurerm_api_management_api_operation" "proxy" {
  for_each = local.create_fallback_operations ? local.fallback_methods : toset([])

  operation_id        = lower("proxy-${each.value}")
  api_name            = azurerm_api_management_api.backend.name
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  display_name        = "Proxy ${each.value}"
  method              = each.value
  url_template        = "/*"

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_api_policy" "backend_forwarding" {
  api_name            = azurerm_api_management_api.backend.name
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <set-backend-service base-url="${var.backend_url}" />
  </inbound>
  <backend>
    <base />
    <forward-request />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML
}
