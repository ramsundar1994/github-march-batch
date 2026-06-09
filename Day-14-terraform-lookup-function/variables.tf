variable "env" {
  default = "Dev"
}
variable "vm_size" {
  type = map(string)
  default = {
    dev  = "Standard_D4s_v3"
    prod = "Standard_D2s_v3"
    test = "Standard_B2s"
  }
}