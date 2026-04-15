#Input variable types
#1 Inline variable
variable "resource_group" {
  type        = string
  default     = "Testing-RG"
  description = "this is for testing resource group"
}
variable "location" {
  type        = string
  default     = "eastus"
  description = "this is for location"
}
resource "azurerm_resource_group" "rg-name" {
  name     = var.resource_group
  location = var.location
}
#2 External variables
resource "azurerm_resource_group" "rg2" {
  name = var.resource_group1
  location = var.location1
}
#3 External variables with separate input file (terraform.tfvars)
resource "azurerm_resource_group" "rg3" {
  name = var.rg3
  location = var.loc3
}