resource "azurerm_resource_group" "simple-web-api-rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    "createdUsing" = "terraform"
    "owner" = "krishnakant"
  }
}

resource "azurerm_kubernetes_cluster" "simple-web-api-aks" {
  name                = var.kubernetes_cluster_name
  location            = azurerm_resource_group.simple-web-api-rg.location
  resource_group_name = azurerm_resource_group.simple-web-api-rg.name
  dns_prefix          = "simple-web-api-dnsprefix"
  kubernetes_version  = var.kubernetes_version

  tags = {
    "createdUsing" = "terraform"
    "owner" = "krishnakant"
  }
  
  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_DS1_v2"
    type            = "VirtualMachineScaleSets"
    os_disk_size_gb = 128
  }

  service_principal {
    client_id     = var.serviceprinciple_id
    client_secret = var.serviceprinciple_key
  }

  # linux_profile {
  #   admin_username = "azureuser"
  #   ssh_key {
  #     key_data = var.ssh_key
  #   }
  # }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "Standard"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = false
    }
  }
}