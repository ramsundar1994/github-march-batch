resource "azurerm_resource_group" "rg" {
  name     = "multiplevm-rg"
  location = "East US"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-01"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}
## Count Meta data for multiple NIC Creations
resource "azurerm_network_interface" "nic" {
  count               = 2                       ## 0,1
  name                = "vm-nic-${count.index}" ## vm-nic-0, vm-nic-1
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}
## public IP
resource "azurerm_public_ip" "pip" {
  count               = 2
  name                = "vm-pip-${count.index}" ## vm-pip-0, vm-pip-1
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
resource "azurerm_windows_virtual_machine" "vm" {
  count               = 2
  name                = "vm-windows-${count.index}" ## vm-windows-0, vm-windows-1
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  admin_password        = "Password1234!"
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
resource "null_resource" "null" {
  count = 2
  provisioner "local-exec" {
    command = "echo ${azurerm_public_ip.pip[count.index].ip_address} >> ipaddress.txt"
  }

}