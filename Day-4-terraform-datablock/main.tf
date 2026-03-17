data "azurerm_resource_group" "rg-01" {
  name = "datablock-rg"
}
# create new disk under existing resource group
resource "azurerm_managed_disk" "disk-01" {
  name                 = "sample-disk-01"
  resource_group_name  = data.azurerm_resource_group.rg-01.name
  location             = data.azurerm_resource_group.rg-01.location
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 10
  create_option        = "Empty"
}
