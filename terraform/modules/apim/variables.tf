variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "apim_name" {
  type = string
}

variable "publisher_name" {
  type = string
}

variable "publisher_email" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "Developer_1"
}

variable "virtual_network_type" {
  type    = string
  default = "External"
}

variable "subnet_id" {
  type = string
}

variable "backend_url" {
  type = string
}

variable "backend_protocol" {
  type    = string
  default = "http"
}

variable "api_name" {
  type    = string
  default = "aks-api"
}

variable "api_display_name" {
  type    = string
  default = "AKS API"
}

variable "api_path" {
  type    = string
  default = "api"
}

variable "api_subscription_required" {
  type    = bool
  default = false
}

variable "enable_fallback_operations" {
  type    = bool
  default = true
}

variable "api_openapi_spec_format" {
  type    = string
  default = "openapi+json"
}

variable "api_openapi_spec_content" {
  type    = string
  default = null
}
