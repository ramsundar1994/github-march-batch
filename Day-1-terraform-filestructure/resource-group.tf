resource "azurerm_resource_group" "rg-01" {
  name = "terraform-rg"
  location = "eastus"
}
resource "azurerm_resource_group" "rg-02" {
  name = "terraform2-rg"
  location = "eastus"
}