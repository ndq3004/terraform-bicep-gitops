terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {
    # Configuration loaded from backend-stg.hcl via: terraform init -backend-config=backend-stg.hcl
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_password" "sql_admin" {
  length  = 24
  special = true
}

module "network" {
  source = "../../modules/network"

  resource_group_name          = azurerm_resource_group.this.name
  location                     = var.location
  vnet_name                    = "vnet-${local.name_prefix}"
  address_space                = var.vnet_address_space
  apim_subnet_cidr             = var.apim_subnet_cidr
  aks_subnet_cidr              = var.aks_subnet_cidr
  private_endpoint_subnet_cidr = var.private_endpoint_subnet_cidr
}

module "monitor" {
  source = "../../modules/monitor"

  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  workspace_name      = "law-${local.name_prefix}"
}

module "acr" {
  source = "../../modules/acr"

  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  acr_name            = replace("acr${local.name_prefix}", "-", "")
  sku                 = var.acr_sku
}

module "keyvault" {
  source = "../../modules/keyvault"

  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  key_vault_name      = replace("kv-${local.name_prefix}", "_", "-")
}

module "aks" {
  source = "../../modules/aks"

  resource_group_name             = azurerm_resource_group.this.name
  location                        = var.location
  cluster_name                    = "aks-${local.name_prefix}"
  dns_prefix                      = "aks-${local.name_prefix}"
  kubernetes_version              = var.kubernetes_version
  private_cluster_enabled         = var.aks_private_cluster_enabled
  sku_tier                        = var.aks_sku_tier
  subnet_id                       = module.network.aks_subnet_id
  system_node_count               = var.system_node_count
  system_node_vm_size             = var.system_node_vm_size
  system_min_count                = var.system_min_count
  system_max_count                = var.system_max_count
  service_cidr                    = var.service_cidr
  dns_service_ip                  = var.dns_service_ip
  log_analytics_workspace_id      = module.monitor.id
  acr_id                          = module.acr.id
  az_count                        = var.az_count
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
}

module "apim" {
  source = "../../modules/apim"

  resource_group_name  = azurerm_resource_group.this.name
  location             = var.location
  apim_name            = replace("apim-${local.name_prefix}", "_", "-")
  publisher_name       = var.apim_publisher_name
  publisher_email      = var.apim_publisher_email
  sku_name             = var.apim_sku_name
  virtual_network_type = var.apim_virtual_network_type
  subnet_id            = module.network.apim_subnet_id
  backend_url          = var.aks_backend_url
  backend_protocol     = var.aks_backend_protocol
  api_name             = var.apim_api_name
  api_display_name     = var.apim_api_display_name
  api_path             = var.apim_api_path
}

module "sql" {
  source = "../../modules/sql"

  resource_group_name          = azurerm_resource_group.this.name
  location                     = var.location
  server_name                  = replace("sql-${local.name_prefix}", "_", "-")
  database_name                = var.sql_database_name
  administrator_login          = var.sql_admin_login
  administrator_login_password = random_password.sql_admin.result
  database_sku_name            = var.sql_database_sku_name
  zone_redundant               = var.az_count > 1 ? true : false
  max_size_gb                  = var.sql_max_size_gb
  private_endpoint_subnet_id   = module.network.private_endpoint_subnet_id
  vnet_id                      = module.network.vnet_id
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin.result
  key_vault_id = module.keyvault.id
}

resource "azurerm_role_assignment" "aks_keyvault_secrets_user" {
  scope                = module.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.aks.kubelet_object_id
}

resource "azurerm_role_assignment" "apim_keyvault_secrets_user" {
  scope                = module.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.apim.principal_id
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "aks_name" {
  value = module.aks.name
}

output "apim_name" {
  value = module.apim.name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "sql_server_name" {
  value = module.sql.server_name
}

output "key_vault_uri" {
  value = module.keyvault.vault_uri
}
