variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "server_name" {
  type = string
}

variable "database_name" {
  type = string
}

variable "administrator_login" {
  type = string
}

variable "administrator_login_password" {
  type    = string
  default = null
}

variable "database_sku_name" {
  type    = string
  default = "GP_S_Gen5_1"
}

variable "zone_redundant" {
  type    = bool
  default = false
}

variable "max_size_gb" {
  type    = number
  default = 32
}

variable "private_endpoint_subnet_id" {
  type = string
}

variable "vnet_id" {
  type = string
}
