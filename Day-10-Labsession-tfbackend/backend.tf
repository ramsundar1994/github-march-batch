terraform {
  backend "azurerm" {
    resource_group_name  = "Devops-RG"
    storage_account_name = "storage1419413"
    container_name       = "tfstate"
    key                  = "dev_terraform.tfstate"
  }
}