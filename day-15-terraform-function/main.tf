resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-function"
  location = "eastus"
}
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-terraform-function"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_network_security_rule" "nsg_rule" {
  for_each = {
    for idx, port in distinct(var.allowed_ports) : idx => port
  }
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
  name                        = "Allow-port-${each.value}"
  priority                    = 100 + each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform-function"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet_details
  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}