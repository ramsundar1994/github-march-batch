## RG Creation using modules
module "rg" {
  source              = "../modules/resource-group"
  resource_group_name = "rg-terraform-modules"
  location            = "East US"
}
## Network creation using network modules
module "network" {
  source              = "../modules/networks"
  vnet_name           = "vnet-test01"
  address_space       = ["10.0.0.0/22"]
  location            = module.rg.rg-location
  resource_group_name = module.rg.rg-name
} 