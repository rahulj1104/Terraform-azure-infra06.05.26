terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.67.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}


# Resource Group
resource "azurerm_resource_group" "first-RG" {
  name     = var.resource_group_name
  location = var.location
}

# Storage Account
resource "azurerm_storage_account" "Firstrahul-storage88" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.first-RG.name
  location                 = azurerm_resource_group.first-RG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# VNet
resource "azurerm_virtual_network" "rahulvnet88" {
  name                = var.vnet_name
  location            = azurerm_resource_group.first-RG.location
  resource_group_name = azurerm_resource_group.first-RG.name
  address_space       = var.vnet_address_space
}

# Subnet
resource "azurerm_subnet" "rahulsubnet88" {
  name                 = var.subnet_name 
  resource_group_name  = azurerm_resource_group.first-RG.name
  virtual_network_name = azurerm_virtual_network.rahulvnet88.name
  address_prefixes     = var.subnet_prefix
}

# NIC1
resource "azurerm_network_interface" "nic1" {
  name                = var.nic1_name
  location            = azurerm_resource_group.first-RG.location
  resource_group_name = azurerm_resource_group.first-RG.name

ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.rahulsubnet88.id
    private_ip_address_allocation = "Dynamic"
  }
  
}

# NIC2
resource "azurerm_network_interface" "nic2" {
  name                = var.nic2_name
  location            = azurerm_resource_group.first-RG.location
  resource_group_name = azurerm_resource_group.first-RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.rahulsubnet88.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VM1
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = var.vm_name 
  resource_group_name = azurerm_resource_group.first-RG.name
  location            = azurerm_resource_group.first-RG.location
  size                = var.vm_size 

  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
#Bastion Subnet
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.first-RG.name
  virtual_network_name = azurerm_virtual_network.rahulvnet88.name
  address_prefixes     = var.bastion_subnet_prefix
}
#Public IP for Bastion
resource "azurerm_public_ip" "bastion_pip" {
  name                = var.bastion_pip_name
  location            = azurerm_resource_group.first-RG.location
  resource_group_name = azurerm_resource_group.first-RG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
#Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name 
  location            = azurerm_resource_group.first-RG.location
  resource_group_name = azurerm_resource_group.first-RG.name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
#Public IP for NAT
resource "azurerm_public_ip" "nat_pip" {
  name                = var.nat_pip_name
  location            = azurerm_resource_group.first-RG.location
  resource_group_name = azurerm_resource_group.first-RG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
#NAT Gateway
resource "azurerm_nat_gateway" "nat" {
  name                = var.nat_name
  location            = azurerm_resource_group.first-RG.location
  resource_group_name = azurerm_resource_group.first-RG.name
  sku_name            = "Standard"

  idle_timeout_in_minutes = 10   
}
#Attach Public IP to NAT
resource "azurerm_nat_gateway_public_ip_association" "nat_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}
#Attach NAT to Subnet
resource "azurerm_subnet_nat_gateway_association" "nat_subnet_assoc" {
  subnet_id      = azurerm_subnet.rahulsubnet88.id
  nat_gateway_id = azurerm_nat_gateway.nat.id

  depends_on = [
    azurerm_nat_gateway_public_ip_association.nat_ip_assoc
  ]
}
#Create NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "my-nsg"
  location            = azurerm_resource_group.first-RG.location
  resource_group_name = azurerm_resource_group.first-RG.name
}
#Add Outbound rule to NSG
resource "azurerm_network_security_rule" "allow_outbound" {
  name                        = "Allow-Internet-Outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.first-RG.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
#Attach NSG to subnet
resource "azurerm_subnet_network_security_group_association" "nsg_subnet_assoc" {
  subnet_id                 = azurerm_subnet.rahulsubnet88.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

  