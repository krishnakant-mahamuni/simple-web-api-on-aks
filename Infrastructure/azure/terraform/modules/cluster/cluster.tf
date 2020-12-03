resource "azurerm_resource_group" "simple-web-api-rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    managedby = "terraform"
  }
}

resource "azurerm_kubernetes_cluster" "simple-web-api-aks" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.simple-web-api-rg.location
  resource_group_name = azurerm_resource_group.simple-web-api-rg.name
  dns_prefix          = "${var.prefix}-aks"
  kubernetes_version  = var.kubernetes_version

  tags = {
    managedby = "terraform"
  }
  
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  tags = {
    managedby = "terraform"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      default_node_pool[0].vm_size
    ]
  }
}