
resource "azurerm_resource_group" "vm" {
    name        = var.resource_group
    location    = var.location
}

resource "azurerm_network_security_group" "vm" {
    name                = "${azurerm_resource_group.vm.name}-nsg"
    resource_group_name = azurerm_resource_group.vm.name
    location            = azurerm_resource_group.vm.location
    security_rule {
        name                            = "SSH_Rule"
        direction                       = "Inbound"
        access                          = "Allow"
        priority                        = "101"
        destination_address_prefix      = "*"
        source_address_prefix           = "*"
        source_port_range               = "*"
        destination_port_range          = "22"
        protocol                        = "Tcp"

    }
    security_rule {
        name                            = "RDP_Rule"
        direction                       = "Inbound"
        access                          = "Allow"
        priority                        = "102"
        destination_address_prefix      = "*"
        source_address_prefix           = "*"
        source_port_range               = "*"
        destination_port_range          = "3389"
        protocol                        = "Tcp"

    }

}

resource "azurerm_virtual_network" "vm" {
    name                    = "${azurerm_resource_group.vm.name}-vnet"
    resource_group_name     = azurerm_resource_group.vm.name
    location                = azurerm_resource_group.vm.location
    address_space           = [ var.vnet_address_space ]
    
}

resource "azurerm_subnet" "vm" {
    name                        = var.subnet_name
    resource_group_name         = azurerm_resource_group.vm.name
    address_prefixes            = [ var.subnet_address_prefix ]
    virtual_network_name        = azurerm_virtual_network.vm.name
}

resource "azurerm_subnet_network_security_group_association" "vm" {
    network_security_group_id = azurerm_network_security_group.vm.id
    subnet_id                 = azurerm_subnet.vm.id
}

resource "azurerm_public_ip" "vm" {
    name                      = "${azurerm_resource_group.vm.name}-pip"
    resource_group_name       = azurerm_resource_group.vm.name
    location                  = azurerm_resource_group.vm.location
    domain_name_label         = var.pip_dns_name
    sku                       = "Basic"
    allocation_method         = "Dynamic"
    ip_version                = "IPv4"
}

resource "azurerm_network_interface" "vm" {
    name                      = "${azurerm_resource_group.vm.name}-${var.vm_name}-nic"
    resource_group_name       = azurerm_resource_group.vm.name
    location                  = azurerm_resource_group.vm.location

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.vm.id
        private_ip_address_allocation = "Dynamic"
        private_ip_address_version    = "IPv4"
        public_ip_address_id          = azurerm_public_ip.vm.id
        
    }
}
resource "random_password" "vm" {
    length           = 16
    special          = true
    override_special = "_%@"
}
resource "azurerm_linux_virtual_machine" "vm" {
    name                    = var.vm_name
    admin_username          = var.admin_user
    admin_password          = random_password.vm.result #var.admin_password
    resource_group_name     = azurerm_resource_group.vm.name
    location                = azurerm_resource_group.vm.location
    computer_name           = var.vm_name
    size                    = var.os_image_size
    disable_password_authentication = false
    network_interface_ids   = [ 
        azurerm_network_interface.vm.id 
        ]
    
    source_image_reference {
        offer     = var.image_offer
        publisher = var.image_publisher
        sku       = var.image_sku
        version   = var.image_version
    }
    os_disk {
        caching              = "ReadWrite"
        disk_size_gb         = var.os_disk_size
        storage_account_type = "Premium_LRS"
    }
}
