variable "resource_group" {
    default = "ubuntu-rg"
}
variable "location" {
    default = "eastus"
}

variable "vnet_address_space" {
    default = "172.16.0.0/16"
}
variable "subnet_name" {
    default = "Linux-subnet"
}

variable "vm_name" {
    default = "tflinux"
}
variable "admin_user" {
    default = "azadmin"
}

# variable "admin_password" {
#     default = "******"
# }

variable "image_publisher" {
    default="Canonical"       # to get list of image referenes then run following command: az vm image list -l eastus -p Canonical -f 0001-com-ubuntu-server-focal --sku="20_04-lts-gen2" -o table --all  >> C:\Ubuntu_VMSList.txt
}

variable "image_offer" {
    default = "0001-com-ubuntu-server-focal"
}

variable "image_sku" {
    default = "20_04-lts-gen2"
}

variable "image_version" {
    default = "20.04.202209200"
}

variable "os_disk_size" {
    default = 32
}
variable "os_image_size" {
    default = "Standard_B4ms"   # To list the vm sizes  run following command: az vm  list-sizes -l eastus -o table
}

variable "pip_dns_name" {
    default = "tflinux09"  # DNS name should be unique globally.
}

variable "subnet_address_prefix" {
    default = "172.16.0.0/24" 
}