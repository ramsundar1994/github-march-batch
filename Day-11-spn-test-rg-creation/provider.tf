terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.62.1"
    }
  }
}
provider "azurerm" {
  features {}
  client_id = "def23930-6220-450b-ba15-9e6b514a8438"
  client_secret = ""
  tenant_id = "4da0c7c8-386d-4699-b2d6-1bf91c67ed24"
  subscription_id = "48662256-1551-4a3d-8e37-335744834f2e"
}