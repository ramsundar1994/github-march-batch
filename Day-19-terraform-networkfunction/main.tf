variable "vnet_cidr" {
  default = "10.0.0.0/16" ##65536 
}
##example output of subnets
## Syntax: cidrsubnet(base, newbits, subnet_number)  ## 8.8.8.8 = 32 bits /32 /31/30/29/28/27/26/25/24
## 10.0.0.0/24 10.0.1.0/24 10.0.2.0/24
locals {
  web_subnet = cidrsubnet(var.vnet_cidr, 8, 2) # /16 + 8 = 24
  db_subnet  = cidrsubnet(var.vnet_cidr, 9, 1) # /16+ 9 =25 , 10.0.0.0 
  ## IP address or host address 
  ##syntax = cidrhost(subnet, hostnumber)
  web_vm_ip = cidrhost(local.web_subnet, 10) ## web vm ip = 10.0.2.10
  db_vm_ip  = cidrhost(local.db_subnet, 10)  ## db vm ip = 10.0.0.138

}
output "subnets" {
  value = {
    web_subnet = local.web_subnet
    db_subnet  = local.db_subnet
    web_vm_ip  = local.web_vm_ip
    db_vm_ip   = local.db_vm_ip
  }
}