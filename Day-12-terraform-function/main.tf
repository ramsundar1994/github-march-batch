#Terraform function lowercase string ( )
resource "azurerm_resource_group" "example" {
  name     = lower(var.rg-name)
  location = var.location
}

# terraform function format function
resource "azurerm_storage_account" "example" {
  name                     = lower(format("Stg%s%s","Finance",var.env))  ## stgfinancedev
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#terraform replace() function 
#replace(string, substring, replacement)
resource "azurerm_resource_group" "rg2" {
  name     = lower(replace(var.rg2," ","-"))  ## My Resource Group => My-Resource-Group
  location = "eastus"
}

#Example 2 
resource "azurerm_storage_account" "stg2" {
  name                     = lower(replace(format("Stg acc%s%s","Finance",var.env)," ","pr"))  ## stgfinancedev
  resource_group_name      = azurerm_resource_group.rg2.name
  location                 = azurerm_resource_group.rg2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}