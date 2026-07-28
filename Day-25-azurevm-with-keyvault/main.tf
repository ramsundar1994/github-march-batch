## config data block
data "azurerm_client_config" "config" {
  ## Tenant id
  ## Object ID 
  ## subscription id
}
resource "azurerm_resource_group" "rg" {
  name     = "testing-rg"
  location = "eastus"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/24"]
}
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-a"
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.0.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
}
##NIC Creation
resource "azurerm_network_interface" "nic" {
  name                = "nic-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "ipconfig"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.0.5"
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}
##PIP Creation
resource "azurerm_public_ip" "pip" {
  name                = "pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
}
## Generate password
resource "random_password" "psd" {
  length           = 20
  special          = true
  override_special = "!@#$%" ## !jk@we#qkj$skleh%
}
## keyvault creation
resource "azurerm_key_vault" "kv" {
  name                       = "kvtest01234"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  sku_name                   = "standard"
  tenant_id                  = data.azurerm_client_config.config.tenant_id
  rbac_authorization_enabled = true
}
## keyvault secret 
resource "azurerm_key_vault_secret" "kv-secret" {
  name         = "vm-password"
  key_vault_id = azurerm_key_vault.kv.id
  value        = random_password.psd.result
}
## keyvault Role assignment
resource "azurerm_role_assignment" "role" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.config.object_id
}
## virtual machine creations
resource "azurerm_windows_virtual_machine" "name" {
  name                  = "windows-01"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
  }
  admin_username = "vmadmin"
  admin_password = azurerm_key_vault_secret.kv-secret.value
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"

  }
  size = "Standard_D2s_v3"
}
#NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "vm-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
resource "azurerm_network_security_rule" "nsg-rule" {
  name                        = "Allow-RDP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name

}
resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}