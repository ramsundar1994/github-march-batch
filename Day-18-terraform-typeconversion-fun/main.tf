##TYPE CONVERSION FUNCTIONS
locals {
  vm_number = 1
  vm_name   = "vm-${tostring(local.vm_number)}" ## vm_name = vm-1
}
output "vm_name" {
  value = local.vm_name
}
##LOOPING – COUNT (Very Simple)
variable "vm_count" {
  default = 3
}

output "vms" {
  value = [
    for x in range(var.vm_count) : "vm-${x}"
  ]
}

## LOOPING – FOR_EACH (Real-World Style
variable "ports" {
  default = {
    ssh  = 22 ## NSG Rule name = "port-22" , "port-80"
    http = 80
  }
}
output "for_loop" {
  value = {
    for name, port in var.ports : name => "Port-${port}" ## SSh = "port-22" , http = "port-80"
  }
}

##FOR EXPRESSIONS (Filtering & Transformation)
variable "vm_namess" {
  default = ["web-vm", "db-vm"]
}
output "upper_case" {
  value = [for vm in var.vm_namess : upper(vm)]
}