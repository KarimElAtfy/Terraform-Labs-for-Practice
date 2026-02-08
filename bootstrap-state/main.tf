terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "state" {
  name     = var.state_rg_name
  location = var.location
}

resource "azurerm_storage_account" "state" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version           = "TLS1_2"
  https_traffic_only_enabled = true
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"
}