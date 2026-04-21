#external output variables
output "rg-02" {
  value = azurerm_resource_group.rg-ext.name
}
output "rg-loc" {
  value = azurerm_resource_group.rg-ext.location
}