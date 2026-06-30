resource "azurerm_resource_group" "rg" {
  name     = "vnet-rg"
  location = "eastus"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.vnet_cidr]
}
locals {
  subnet_names = [
    "web", ## web = 0
    "app", ## app = 1
    "db",
    "management"
  ]
}
resource "azurerm_subnet" "subnets" {
  for_each = {
    for range, name in local.subnet_names : name => range
  }
  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 8 , each.value)]
  virtual_network_name = azurerm_virtual_network.vnet.name
}