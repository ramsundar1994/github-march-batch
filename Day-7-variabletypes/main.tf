# Terraform variable types
# String variable Example 1
resource "azurerm_resource_group" "rg-name" {
  name     = var.rg
  location = var.loc
}
# List variable - Example 2 , Looping mechanisam - Count
resource "azurerm_resource_group" "multiple-rg" {
  count    = length(var.rg-names)
  name     = var.rg-names[count.index]
  location = var.loc
}
# List variable - Example 3 , Looping mechanisam - for each
resource "azurerm_resource_group" "multiple-locations-rg" {
  for_each = toset(var.multiple-locations)
  name     = "${each.key}-RG"
  location = each.key
}
# Map variable - Example 4 , Looping mechanisam - for each
resource "azurerm_resource_group" "mapping-rg" {
  for_each = var.mapping
  name     = each.key
  location = each.value
}