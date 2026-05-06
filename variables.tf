# Provider Credentials
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "client_id" {
  type        = string
  description = "Azure Client ID"
}

variable "client_secret" {
  type        = string
  description = "Azure Client Secret"
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

# Resource Group
variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
}

# Storage
variable "storage_account_name" {
  type        = string
}

# Network
variable "vnet_name" {
  type        = string
}

variable "vnet_address_space" {
  type        = list(string)
}

variable "subnet_name" {
  type        = string
}

variable "subnet_prefix" {
  type        = list(string)
}

variable "bastion_subnet_prefix" {
  type        = list(string)
}

# NIC
variable "nic1_name" {
  type = string
}

variable "nic2_name" {
  type = string
}

# VM
variable "vm_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

# Bastion & NAT
variable "bastion_name" {
  type = string
}

variable "bastion_pip_name" {
  type = string
}

variable "nat_name" {
  type = string
}

variable "nat_pip_name" {
  type = string
}

# NSG
variable "nsg_name" {
  type = string
}