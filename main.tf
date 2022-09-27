terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.10.0"
    }
  }
}

#lokale variabler
locals {
  rg_name = "rg-${var.prefix}"
  vnet_name = "vnet-${var.prefix}"
  nsg_name = "nsg-${var.prefix}"
  vnet_address_space = ["10.1.0.0/16"]
  subnet_name = "default"
  subnet_prefix = ["10.1.0.0/24"]
}

resource "random_integer" "random" {
  min = 1000
  max = 9999
}

#sette opp provider
provider "azurerm" {
  features {}
}

#sette opp resourcegroup
resource "azurerm_resource_group" "myrg" {
  name = local.rg_name
  location = var.region
  tags = var.tags
}

#definerer vnet
resource "azurerm_virtual_network" "myvnet" {
  name = local.vnet_name
  location = var.region
  resource_group_name = azurerm_resource_group.myrg.name
  address_space = local.vnet_address_space
}

#lager et subent med navn default i vnet
resource "azurerm_subnet" "mysubnet" {
  name = local.subnet_name
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes = local.subnet_prefix
  service_endpoints = [ "Microsoft.Storage" ]
}

#network security group
resource "azurerm_network_security_group" "mynsg" {
  name = local.nsg_name
  location = var.region
  resource_group_name = azurerm_resource_group.myrg.name
  security_rule {
    name                       = "Deny all incoming"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#assosier subnet med nsg
resource "azurerm_subnet_network_security_group_association" "mysubnetass" {
  subnet_id = azurerm_subnet.mysubnet.id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}

#Storage account
resource "azurerm_storage_account" "mysa" {
  name = "sa${var.prefix}${random_integer.random.result}"
  resource_group_name = azurerm_resource_group.myrg.name
  location = var.region
  account_tier = "Standard"
  account_replication_type = "LRS"
  network_rules {
    default_action             = "Deny"
    ip_rules = [ "81.191.45.166" ]
    virtual_network_subnet_ids = [azurerm_subnet.mysubnet.id]
  }

}

#output
output "sa_name" {
  value = azurerm_storage_account.mysa.name
}