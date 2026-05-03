# RG variable using string type
variable "rg" {
  type    = string
  default = "value"
}
variable "loc" {
  type    = string
  default = "eastus"
}
# Terraform variable types - List string
variable "rg-names" {
  type    = list(string)
  default = ["list1", "list2", "list3"]
}
# Terraform variable types - list string for each looping mechanism
variable "multiple-locations" {
  type    = list(string)
  default = ["eastus", "westus", "centralus"]
}
# Terraform variable types - Map string for each looping mechanism
variable "mapping" {
  type = map(string)
  default = {
    "Mapping-RG"  = "eastus"
    "Mapping-RG2" = "westus"
    "Mapping-RG3" = "centralus"
  }
}