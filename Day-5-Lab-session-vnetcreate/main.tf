# resource group for vnet
resource "azurerm_resource_group" "rg" {
  name     = "rg-vnet"
  location = "eastus"
}
resource "azurerm_virtual_network" "vnet-01" {
  name                = "testing-vnet-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/24"]
}
resource "azurerm_subnet" "subnet-01" {
  name                 = "subnet-A"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-01.name
  address_prefixes     = ["10.0.0.0/28"]
}
resource "azurerm_subnet" "subnet-02" {
  name                 = "subnet-B"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-01.name
  address_prefixes     = ["10.0.0.16/28"]
}