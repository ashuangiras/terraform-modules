variable "resource_group_name" {
  description = "Name of the resource group to be created"
}

variable "location" {
  description = "Location for the all the resources"
}

variable "region_prefix" {
  description = "region prefix"
}

variable "tags" {
  description = "tags to be specified"
}

variable "cluster_name" {
  description = "cluster name"
  default     = "k8s"
}

variable "log_analytics_workspace_name" {
  default = "log-gp"
}
variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}
variable "dns_prefix" {
  description = "dns-prefix if any"
}

variable "mode" {
  default = "acr"
}

variable "agent_count" {
  description = "Number of agents required for Kubernetes"
  default     = 2
}

variable "server_principal_username" {
  description = "Server Principal Username for Azure account"
}

variable "server_principal_password" {
  description = "Server Principal password for Azure account"
}

variable "tenant_id" {
  description = "Tenant ID for Azure account"
}

variable "client_id" {
  description = "Client ID for Azure account"
}

variable "client_secret" {
  description = "Client Secret for Azure account"
}

variable "vm_size" {
  description = "Size of the VM to run as nodes"
  default     = "Standard_DS1_v2"
}

variable "create_container_registry" {
  description = "Set to TRUE or FALSE if you want to create a new container registry as well"
  default     = false
}
