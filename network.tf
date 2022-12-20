# resource group data source
data "azurerm_resource_group" "example" {
  name = "core-infra-sandbox-rg"
}

output "id" {
  value = data.azurerm_resource_group.example.id
}

output "location" {
  value = data.azurerm_resource_group.example.location
}

output "name" {
  value = data.azurerm_resource_group.example.name
}

# virtual network data source
data "azurerm_virtual_network" "example" {
  name                = "core-infra-sandbox-vnet"
  resource_group_name = data.azurerm_resource_group.example.name
}

output "vnet_id" {
  value = data.azurerm_virtual_network.example.id
}

output "vnet_name" {
  value = data.azurerm_virtual_network.example.name
}

# subnet data source
data "azurerm_subnet" "example" {
  name                 = "WebSubnet"
  virtual_network_name = data.azurerm_virtual_network.example.name
  resource_group_name  = data.azurerm_resource_group.example.name
}

output "subnet_id" {
  value = data.azurerm_subnet.example.id


}

#core-infra-sandbox-rg
#core-infra-sandbox-vnet
#WebSubnet