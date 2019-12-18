resource "azurerm_resource_group" "k8s-resource-group" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 5
}

locals {
  universal_prefix = "${var.region_prefix}-${var.location}-cdc"
}

resource "azurerm_log_analytics_workspace" "log-analytics-ws" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "${local.universal_prefix}-${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.location
  resource_group_name = azurerm_resource_group.k8s-resource-group.name
  sku                 = var.log_analytics_workspace_sku
  tags                = var.tags
}

resource "azurerm_log_analytics_solution" "log-analytics-solution" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.log-analytics-ws.location
  resource_group_name   = azurerm_resource_group.k8s-resource-group.name
  workspace_resource_id = azurerm_log_analytics_workspace.log-analytics-ws.id
  workspace_name        = azurerm_log_analytics_workspace.log-analytics-ws.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "k8s-cluster" {
  name                = "${local.universal_prefix}-${var.cluster_name}"
  location            = azurerm_resource_group.k8s-resource-group.location
  resource_group_name = azurerm_resource_group.k8s-resource-group.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "agentpool"
    node_count = var.agent_count
    vm_size    = var.vm_size
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.log-analytics-ws.id
    }
  }

  tags = var.tags
}


if var.create_container_registry {
  resource "azurerm_container_registry" "acr" {
    name                = "${var.region_prefix}${var.location}${var.mode}"
    resource_group_name = azurerm_resource_group.k8s-resource-group.name
    location            = azurerm_resource_group.k8s-resource-group.location
    sku                 = "Standard"
    admin_enabled       = true
  }
}
