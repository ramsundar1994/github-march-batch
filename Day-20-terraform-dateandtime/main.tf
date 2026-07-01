##Date and time function
locals {
  current_time = timestamp()
  current_date = formatdate("YYYY-MM-DD", local.current_time)
}
output "current_date_time" {
  value = {
    date = local.current_date
    time = local.current_time
  }
}
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-dateandtime"
  location = "eastus"
  tags = {
    current_time = local.current_time
    current_date = local.current_date
  }
}