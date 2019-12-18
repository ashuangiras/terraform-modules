output "id" {
  value = "${azurerm_kubernetes_cluster.k8s-cluster.id}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.k8s-cluster.kube_config_raw}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.k8s-cluster.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.k8s-cluster.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.k8s-cluster.kube_config.0.cluster_ca_certificate}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s-cluster.kube_config.0.host}"
}
output "namespace" {
  value = "${azurerm_kubernetes_cluster.k8s-cluster.kube_config.0.host}"
}

if var.create_container_registry {
  output "acr-username" {
    value = "${azurerm_container_registry.acr.admin_username}"
  }

  output "acr-password" {
    value = "${azurerm_container_registry.acr.admin_password}"
  }
}