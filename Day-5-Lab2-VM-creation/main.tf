resource "azurerm_resource_group" "rg-name" {
  name     = "VM-RG"
  location = "eastus"
}
#step2 : Vnet and subnet creations 
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-01"
  resource_group_name = azurerm_resource_group.rg-name.name
  location            = azurerm_resource_group.rg-name.location
  address_space       = ["10.0.0.0/24"]
}
resource "azurerm_subnet" "subnet-a" {
  name                 = "subnet-A"
  resource_group_name  = azurerm_resource_group.rg-name.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/28"]
}
#azure public Ip Creations
resource "azurerm_public_ip" "pip" {
  name                = "vm-pip-01"
  resource_group_name = azurerm_resource_group.rg-name.name
  location            = azurerm_resource_group.rg-name.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
#step3 : NIC Card Creations
resource "azurerm_network_interface" "nic-01" {
  name                = "VM-nic-01"
  resource_group_name = azurerm_resource_group.rg-name.name
  location            = azurerm_resource_group.rg-name.location
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet-a.id
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

#step4 : VM Creation
resource "azurerm_windows_virtual_machine" "vm-01" {
  name                  = "windowsvm-01"
  resource_group_name   = azurerm_resource_group.rg-name.name
  location              = azurerm_resource_group.rg-name.location
  size                  = "Standard_D2s_v3"
  admin_username        = "azureuser"
  admin_password        = "Welcome@12345"
  network_interface_ids = [azurerm_network_interface.nic-01.id]
  os_disk {
    name                 = "windowsvm-01-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    version   = "latest"
    sku       = "2022-datacenter-g2"
  }
}
# network security group
resource "azurerm_network_security_group" "nsg-01" {
  name                = "NIC-nsg-01"
  resource_group_name = azurerm_resource_group.rg-name.name
  location            = azurerm_resource_group.rg-name.location
}
#network security rule
resource "azurerm_network_security_rule" "nsg-rule-01" {
  name                        = "RDP-Allow"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg-01.name
  resource_group_name         = azurerm_resource_group.rg-name.name
}
#network security group association with nic card
resource "azurerm_network_interface_security_group_association" "name" {
  network_interface_id      = azurerm_network_interface.nic-01.id
  network_security_group_id = azurerm_network_security_group.nsg-01.id

}

output "vm-pip" {
  value = azurerm_public_ip.pip.ip_address
}