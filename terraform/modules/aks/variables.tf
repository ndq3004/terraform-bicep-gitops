variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "private_cluster_enabled" {
  type    = bool
  default = true
}

variable "sku_tier" {
  type    = string
  default = "Standard"
}

variable "subnet_id" {
  type = string
}

variable "system_node_count" {
  type    = number
  default = 1
}

variable "system_node_vm_size" {
  type    = string
  default = "Standard_B2s_v2"
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

variable "log_analytics_workspace_id" {
  type = string
}

variable "acr_id" {
  type = string
}

variable "az_count" {
  type    = number
  default = 1
}

variable "api_server_authorized_ip_ranges" {
  type    = list(string)
  default = []
}
