resource "azurerm_resource_group" "rg-01" {
  name     = "Testing-RG"
  location = "eastus"
}
resource "azurerm_resource_group" "rg-02" {
  name     = "Second-RG"
  location = "westus2"
}