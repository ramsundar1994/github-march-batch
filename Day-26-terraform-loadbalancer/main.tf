## resource group
resource "azurerm_resource_group" "rg-01" {
  name     = "testing-rg"
  location = "East US"
}
#vNet creations
resource "azurerm_virtual_network" "vnet1" {
  name                = "lb-vnet-001"
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  address_space       = ["10.0.0.0/24"]
}
#subnet creation
resource "azurerm_subnet" "subnet" {
  name                 = "lb-subnet"
  resource_group_name  = azurerm_resource_group.rg-01.name
  address_prefixes     = ["10.0.0.0/28"]
  virtual_network_name = azurerm_virtual_network.vnet1.name
}
## Step1 Public IP Creation
resource "azurerm_public_ip" "publicip" {
  name                = "lb-publicip"
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
##Step 2
## Load balancer
resource "azurerm_lb" "loadbalancer" {
  name                = "lb-01"
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}
## Step 3
resource "azurerm_lb_backend_address_pool" "backendpool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.loadbalancer.id
}
## Step 4
resource "azurerm_lb_probe" "lbprobe" {
  name            = "lb-probe"
  loadbalancer_id = azurerm_lb.loadbalancer.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}
## Step 5
resource "azurerm_lb_rule" "lbrule" {
  name                           = "lb-rule"
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-ip-config"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backendpool.id]
  probe_id                       = azurerm_lb_probe.lbprobe.id
}
## Step6 VM NIC
resource "azurerm_network_interface" "nic1" {
  name                = "vm-nic-01"
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
## step 7 associate NIC to LB backend pool
resource "azurerm_network_interface_backend_address_pool_association" "nic1_lb_association" {
  network_interface_id    = azurerm_network_interface.nic1.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool.id
}
## Step 8 NSG Creations
resource "azurerm_network_security_group" "nsg" {
  name                = "lb-nsg"
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name
}
resource "azurerm_network_security_rule" "nsg_rule" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg-01.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "nsg_rule_ssh" {
  name                        = "allow-RDP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg-01.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_interface_security_group_association" "nic1_nsg_association" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
## Step 9 VM Creation
resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "lb-vm-01"
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "Welcome@12345"
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
## Step 10 Enable IIS on vm using extension
#VM Extension for enabling IIS server on the VM
resource "azurerm_virtual_machine_extension" "vm-extension" {
  name                 = "IIS"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
{
  "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools"
}
SETTINGS
}
## Step 11 NAT Rule for VM RDP
resource "azurerm_lb_nat_rule" "nat_rule" {
  name                           = "rdp-nat-rule"
  resource_group_name            = azurerm_resource_group.rg-01.name
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "frontend-ip-config"
}
## Step 12 Associate NAT rule to VM NIC
resource "azurerm_network_interface_nat_rule_association" "nic1_nat_association" {
  network_interface_id  = azurerm_network_interface.nic1.id
  ip_configuration_name = "internal"
  nat_rule_id           = azurerm_lb_nat_rule.nat_rule.id
}
output "public_ip_address" {
  value = azurerm_public_ip.publicip.ip_address
}