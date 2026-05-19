rg-details = {
  name     = "vm-creation-rg"
  location = "eastus"
}
#vnet details
vnet_name = "vm-vnet-01"
#address space for vnet
address_space = "10.0.1.0/24"
#subnet details
subnet_details = {
  name           = "vm-subnet-01"
  address_prefix = ["10.0.1.0/24", "10.0.2.0/24"]
}
#nic details
vm-nic = ["vm-nic-01", "vm-nic-02"]
#vm details
vm_details = {
  name           = "windowsvm-01"
  size           = "Standard_D2s_v3"
  admin_username = "azureuser"
  admin_password = "P@ssw0rd1234"
  osdisk_name    = "vm-01-osdisk"
  publisher      = "MicrosoftWindowsServer"
  offer          = "WindowsServer"
  sku            = "2022-datacenter"
  version        = "latest"
}     