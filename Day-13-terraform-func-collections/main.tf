resource "azurerm_resource_group" "rg-details" {
  count = length(var.rg-details)  #count = 3
  name = var.rg-details[count.index]  #rg-01, rg-02, rg-03
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet-details" {
depends_on = [azurerm_resource_group.rg-details] ## Explicit dependency
name = "vnet-01"
resource_group_name = azurerm_resource_group.rg-details[1].name
location = azurerm_resource_group.rg-details[1].location
address_space = ["10.0.0.0/24"]
}
resource "azurerm_virtual_network" "vnet-details-01" {
depends_on = [azurerm_resource_group.rg-details] ## Explicit dependency
name = "vnet-02"
resource_group_name = azurerm_resource_group.rg-details[2].name
location = azurerm_resource_group.rg-details[2].location
address_space = ["10.0.1.0/24"]
}