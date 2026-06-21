variable "project_name" {
  type    = string
  default = "gitops"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "resource_group_name" {
  type    = string
  default = "rg-gitops-dev-weu"
}

variable "vnet_address_space" {
  type    = string
  default = "10.10.0.0/16"
}

variable "apim_subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}

variable "aks_subnet_cidr" {
  type    = string
  default = "10.10.2.0/23"
}

variable "private_endpoint_subnet_cidr" {
  type    = string
  default = "10.10.4.0/24"
}

variable "acr_sku" {
  type    = string
  default = "Standard"
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "aks_private_cluster_enabled" {
  type    = bool
  default = true
}

variable "aks_sku_tier" {
  type    = string
  default = "Standard"
}

variable "system_node_count" {
  type    = number
  default = 1
}

variable "system_node_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "system_min_count" {
  type    = number
  default = 1
}

variable "system_max_count" {
  type    = number
  default = 3
}

variable "service_cidr" {
  type    = string
  default = "10.240.0.0/16"
}

variable "dns_service_ip" {
  type    = string
  default = "10.240.0.10"
}

variable "az_count" {
  type    = number
  default = 1
}

variable "api_server_authorized_ip_ranges" {
  type    = list(string)
  default = []
}

variable "apim_publisher_name" {
  type    = string
  default = "Quan"
}

variable "apim_publisher_email" {
  type    = string
  default = "quan@example.com"
}

variable "apim_sku_name" {
  type    = string
  default = "Developer_1"
}

variable "apim_virtual_network_type" {
  type    = string
  default = "External"
}

variable "aks_backend_url" {
  type    = string
  default = "http://aks-backend.internal"
}

variable "aks_backend_protocol" {
  type    = string
  default = "http"
}

variable "apim_api_name" {
  type    = string
  default = "aks-api"
}

variable "apim_api_display_name" {
  type    = string
  default = "AKS API"
}

variable "apim_api_path" {
  type    = string
  default = "api"
}

variable "sql_admin_login" {
  type    = string
  default = "sqladminuser"
}

variable "sql_database_name" {
  type    = string
  default = "appdb"
}

variable "sql_database_sku_name" {
  type    = string
  default = "GP_S_Gen5_1"
}

variable "sql_max_size_gb" {
  type    = number
  default = 32
}

variable "state_resource_group_name" {
  type    = string
  default = "rg-gitops-dev-state-weu"
}

variable "state_storage_account_name" {
  type    = string
  default = "stgitopsdevstateweu"
}

variable "state_container_name" {
  type    = string
  default = "tfstate"
}