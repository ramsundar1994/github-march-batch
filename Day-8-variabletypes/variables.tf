variable "rg-details" {
  type = object({
    name = string
    location = string
    tag = map(string)
  })
  default = {
    name = "object-rg"
    location = "eastus"
    tag = {
        environment = "dev"
    }
  }
}

# Nested variables for objects

variable "nested-rg"{
type = map(object({
    name = string
    location = string
    tag = map(string)
  }))
}