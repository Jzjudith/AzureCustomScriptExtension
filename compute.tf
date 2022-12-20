resource "azurerm_public_ip" "windows" {
  name                = "winext-test-pip"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  allocation_method   = "Static"

  tags = {
    environment = "Development"
  }
}

resource "azurerm_network_interface" "windows" {
  name                = "winext-test-nic"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows.id
  }
}

resource "azurerm_public_ip" "linux" {
  name                = "linext-test-pip"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  allocation_method   = "Static"

  tags = {
    environment = "Development"
  }
}

resource "azurerm_network_interface" "linux" {
  name                = "linext-test-nic"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux.id
  }
}


resource "azurerm_windows_virtual_machine" "windows" {
  name                = "win-ext-testvm"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  size                = "Standard_B2ms"
  admin_username      = "devlab"
  admin_password      = "Devlab123"
  network_interface_ids = [
    azurerm_network_interface.windows.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "linux" {
  name                            = "lin-ext-testvm"
  resource_group_name             = data.azurerm_resource_group.example.name
  location                        = data.azurerm_resource_group.example.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password = "Devlab123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.linux.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "windows" {
  name                 = "wincustomext"
  virtual_machine_id   = azurerm_windows_virtual_machine.windows.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings             = <<SETTINGS
{
  "commandToExecute": "powershell -encodeexamplecommand ${textencodebase64(file("/scripts/iis-install.ps1"), "UTF-16LE")}" 

 }
 SETTINGS

   
  depends_on = [
    azurerm_windows_virtual_machine.windows
  ]

  tags = {
    environment = "Development"
  }

}

resource "azurerm_virtual_machine_extension" "linux" {
  name                 = "lincustomext"
  virtual_machine_id   = azurerm_linux_virtual_machine.linux.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
  "fileUris": ["https://github.com/Jzjudith/AzureCustomScriptExtension"],
  "commandToExecute": "sh script.sh"
 }
SETTINGS


  tags = {
    environment = "Development"
  }
}