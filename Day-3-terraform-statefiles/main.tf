#resource group
resource "azurerm_resource_group" "rg-01" {
  name     = "resource-group-01"
  location = "eastus"
  tags = {
    "env"         = "prod"
    "application" = "testing"
  }
}
# resource "azurerm_resource_group" "rg-02" {
#   name     = "resource-group-03"
#   location = "westus"
#   tags = {
#     "env"         = "nonprod"
#     "application" = "testing"
#   }
# }
# resource "azurerm_resource_group" "rg-03" {
#   name = "testing-rg"
#   location = "eastus"
#   tags = { 
#     "env" = "testing"
#     "appid" = "01"       
#     }
# }