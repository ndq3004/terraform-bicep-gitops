variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = string
}

variable "apim_subnet_name" {
  type    = string
  default = "snet-apim"
}

variable "aks_subnet_name" {
  type    = string
  default = "snet-aks"
}

variable "private_endpoint_subnet_name" {
  type    = string
  default = "snet-private-endpoints"
}

variable "apim_subnet_cidr" {
  type = string
}

variable "aks_subnet_cidr" {
  type = string
}

variable "private_endpoint_subnet_cidr" {
  type = string
}
