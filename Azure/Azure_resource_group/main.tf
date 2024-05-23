resource "azurerm_resource_group" "RG_test" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_public_ip" "PublicIP_test" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.Persistent_test.name
  location            = azurerm_resource_group.Persistent_test.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}
