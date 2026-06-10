variable "allowed_ports" {
  default = ["80", "443", "22", "22"] #key = value :  0 = 80 , 1 = 443 , 2 = 22 
}
variable "subnet_details" {
  default = {
    "subnet-a-web" = "10.0.1.0/24"
    "subnet-b-app" = "10.0.2.0/24"
    "subnet-c-db"  = "10.0.3.0/24"
  }

}