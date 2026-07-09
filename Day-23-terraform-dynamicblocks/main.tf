resource "azurerm_resource_group" "rg" {
  name     = "rg-dynamic-blocks"
  location = "East US"
}
##network security group creation using dynamic block
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-dynamic-blocks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dynamic "security_rule" {
    for_each = var.nsg_rule
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix

    }
  }
}
## virtual network and subnet creation using dynamic block
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-dynamic-blocks"
  address_space       = ["10.0.0.0/22"] ##1024 IP addresses
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  dynamic "subnet" {
    for_each = var.subnet
    content {
      name             = subnet.value.name
      address_prefixes = subnet.value.address_prefix
    }
  }
}
##multipl NIC creations
resource "azurerm_network_interface" "nics" {
  for_each = {
    for subnet in azurerm_virtual_network.vnet.subnet : subnet.name => subnet
  }
  name                = "nic-${each.key}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "ipconfig-${each.key}-01"
    subnet_id                     = each.value.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  for_each                  = azurerm_network_interface.nics
  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "windows-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "P@ssword1234!"
  network_interface_ids = [ for nic in azurerm_network_interface.nics : nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}