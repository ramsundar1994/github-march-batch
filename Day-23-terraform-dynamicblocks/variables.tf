variable "nsg_rule" {
  default = [
    {
      name                       = "Allow-RDP"
      priority                   = "100"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp",
      source_port_range          = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      destination_port_range     = "3389"
    },
    {
      name                       = "Allow-Winrm"
      priority                   = "110"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp",
      source_port_range          = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      destination_port_range     = "5985"
    }
  ]
}
variable "subnet" {
  default = [
    {
      name           = "frontend-subnet"
      address_prefix = ["10.0.0.0/24"]
    },
    {
      name           = "backend-subnet"
      address_prefix = ["10.0.1.0/24"]
    }
  ]
}