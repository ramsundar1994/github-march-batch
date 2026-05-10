# Terraform Objects
resource "azurerm_resource_group" "rg" {
  name = var.rg-details.name
  location = var.rg-details.location
  tags = var.rg-details.tag
}

# Terraform Nested objects

resource "azurerm_resource_group" "rg2" {
  name = var.nested-rg["dev"].name
  location = var.nested-rg["dev"].location
  tags = var.nested-rg["dev"].tag
}
resource "azurerm_resource_group" "rg3" {
  name = var.nested-rg["prod"].name
  location = var.nested-rg["prod"].location
  tags = var.nested-rg["prod"].tag
}