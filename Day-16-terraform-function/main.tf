resource "azurerm_resource_group" "rg" {
  name     = "testing-rg"
  location = "eastus"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "testing-vnet"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
##For Expression
resource "azurerm_subnet" "subnets" {
    for_each = {
        for id, cidr in var.subnet-cidr : id => cidr   ##  0 = 10.0.0.0/27 , 1 = 10.0.0.32/27
    }
    name = "subnet-${each.key}"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = [each.value]
}