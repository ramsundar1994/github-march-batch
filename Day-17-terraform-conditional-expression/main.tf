##conditional expression
## condition ? true_value : false_value  1:0 
resource "azurerm_resource_group" "rg" {
  count    = var.env == "prod" ? 1 : 0
  name     = "production-rg"
  location = "eastus"
}
locals {
    storage_type = var.env1 == "prod" ? "GRS" : "LRS"
}
output "storage_type" {
    value = local.storage_type
}