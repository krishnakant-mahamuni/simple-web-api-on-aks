provider "azurerm" {
  version = "=2.5.0"

  subscription_id = var.subscription_id
  client_id       = var.serviceprinciple_id
  client_secret   = var.serviceprinciple_key
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
  serviceprinciple_id     = var.client_id
  serviceprinciple_key    = var.client_secret
  location                = var.location
  kubernetes_version      = var.kubernetes_version
}

module "acr" {
  source                   = "./modules/acr/"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku
}