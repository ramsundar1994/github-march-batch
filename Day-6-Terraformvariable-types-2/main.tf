#Example :1 inline local variables
locals {
  resource_group_name = "Testing-RG"
  location            = "eastus"
}
resource "azurerm_resource_group" "rg-name" {
  name     = local.resource_group_name
  location = local.location
}
#Example :2 External Local variables
resource "azurerm_resource_group" "rg-ext" {
  name     = local.rg
  location = local.loc
}
#Example 3 : inline output variable
output "rg-details" {
  value = azurerm_resource_group.rg-name.name
}
output "rg-details-loc" {
  value = azurerm_resource_group.rg-name.location
}