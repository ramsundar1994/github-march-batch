resource "azurerm_resource_group" "rg" {
  name     = "testing-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "stg" {
  name                     = "stg197368"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "stg_container" {
 depends_on = [ azurerm_storage_account.stg]
 name = "backend-container"
 storage_account_name = azurerm_storage_account.stg.name
 container_access_type = "private"
}