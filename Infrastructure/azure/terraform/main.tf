provider "azurerm" {
  version = "=2.5.0"

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}

terraform {
  backend "azurerm" {
  }
}

module "cluster" {
  source                  = "./modules/cluster/"
  resource_group_name     = var.resource_group_name
  location                = var.location
  kubernetes_version      = var.kubernetes_version
  prefix                  = var.prefix
  node_count              = var.node_count
  node_vm_size            = var.node_vm_size
}

module "acr" {
  source                   = "./modules/acr/"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku
}