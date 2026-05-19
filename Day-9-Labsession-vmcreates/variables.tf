variable "rg-details" {
  type = object({
    name     = string
    location = string
  })
  default = {
    name     = ""
    location = ""
  }
  description = "this is the resourcegroup for vm"
}
variable "vnet_name" {
  type        = string
  default     = ""
  description = "this is the vnet"
}
variable "address_space" {
  type        = string
  default     = ""
  description = "this is the address space for vnet"
}
variable "tags" {
  type = map(string)
  default = {
    "Appowner"    = "john.doe"
    "Environment" = "dev"
    "Department"  = "IT"
  }
}
variable "subnet_details" {
  type = object({
    name           = string
    address_prefix = list(string)
  })
  default = {
    name           = ""
    address_prefix = [""]
  }
}
variable "vm-nic" {
  type    = list(string)
  default = [""]
}
variable "vm_details" {
  type = object({
    name           = string
    size           = string
    admin_username = string
    admin_password = string
    osdisk_name    = string
    publisher      = string
    offer          = string
    sku            = string
    version        = string
  })
}