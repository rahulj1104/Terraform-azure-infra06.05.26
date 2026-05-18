resource_group_name = "My-resources"
location            = "Central India"

storage_account_name = "myrahulstorage888888"

vnet_name           = "myrahul-vnet88"
vnet_address_space  = ["10.0.0.0/16"]

subnet_name   = "myrahul-subnet88"
subnet_prefix = ["10.0.1.0/24"]

bastion_subnet_prefix = ["10.0.2.0/27"]

nic1_name = "nic-vm1"
nic2_name = "nic-vm2"

vm_name        = "vm1"
vm_size        = "Standard_D2s_v3"
admin_username = "azureuser"
admin_password = "Password@1234"

bastion_name     = "my-bastion"
bastion_pip_name = "bastion-pip"

nat_name     = "my-nat-gateway"
nat_pip_name = "nat-pip"

nsg_name = "my-nsg"