variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "virtual_network_address_space" {
  description = "Address space of virtual network"
  type = "list"
  default = ["10.3.0.0/16"]
}

variable "test_subnet_address_prefix" {
  description = "Address prefix for test subnet"
  default = "10.3.1.0/24"
}

variable "proxy_subnet_address_prefix" {
  description = "Address prefix for proxy subnet"
  default = "10.3.2.0/24"
}

variable "location" {
  description = "Location"
  default = "Japan West"
}

variable "prefix" {
  description = "Prefix for all resource names"
  default = "kamol"
}

variable "suffix" {
  description = "Suffix for all resource names"
  default = "v1"
}

variable "proxy_lp_ip" {
  description = "Proxy LB's private IP"
  default = "10.3.2.100"
}

variable "proxy_vm_count" {
  description = "number of proxy VMs behind LB"
  default = 2
}

variable "vm_hostname" {}
variable "vm_admin_username" {}
variable "vm_admin_password" {}
variable "vm_admin_public_key" {}
variable "vm_admin_private_key" {}
