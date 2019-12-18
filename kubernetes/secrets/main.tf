
variable "secret_name" {
  description = "secret name"
}

variable "namespace" {}

variable "data" {
  description = "list of secrets you want to add"
}


resource "kubernetes_secret" "op-secret" {
  metadata {
    name      = "${var.secret_name}"
    namespace = "${var.namespace}"
  }
  data = "${var.data}"
  type = "Opaque"
}
