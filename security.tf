
resource "azurerm_network_security_group" "example" {
  name                = "ext-test-nnsg"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  security_rule {
    name                                       = "Allow-ALL=Inbound"
    priority                                   = 101
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    destination_port_range                     = "*"
    source_address_prefix                      = "*"
    destination_address_prefix              = "*"
  }

   security_rule {
    name                                       = "Allow-ALL=Outbound"
    priority                                   = 102
    direction                                  = "Outbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    destination_port_range                     = "*"
    source_address_prefix                      = "*"
    destination_address_prefix              = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "windows" {
  network_interface_id      = azurerm_network_interface.windows.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_interface_security_group_association" "linux" {
  network_interface_id      = azurerm_network_interface.linux.id
  network_security_group_id = azurerm_network_security_group.example.id
}


   