variable "namespace" {}


resource "kubernetes_config_map" "redis-cluster-config-map" {
  metadata {
    name      = "redis-cluster"
    namespace = "${var.namespace}"
  }

  data = {
    "update-node.sh" = "${file("${path.module}/update-node.sh")}"
    "redis.conf"     = "${file("${path.module}/redis.conf")}"
  }
}

resource "kubernetes_service" "redis-cluster-service" {
  metadata {
    name      = "redis-cluster"
    namespace = "${var.namespace}"

    labels = {
      app  = "redis"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    type = "ClusterIP"
    selector = {
      app = "redis-cluster"
    }
    port {
      port        = 6379
      name        = "client"
      target_port = 6379
    }
  }
}


resource "kubernetes_stateful_set" "redis-cluster" {
  metadata {

    labels = {
      app                               = "redis-cluster"
      "kubernetes.io/cluster-service"   = "true"
      "addonmanager.kubernetes.io/mode" = "Reconcile"
      version                           = "v2.2.1"
    }

    name      = "redis-cluster"
    namespace = "${var.namespace}"

  }

  spec {
    replicas = 6
    selector {
      match_labels = {
        app = "redis-cluster"
      }
    }
    service_name = "redis-cluster"

    template {
      metadata {
        labels = {
          app = "redis-cluster"
        }
        annotations = {}
      }

      spec {
        container {
          name              = "redis"
          image             = "redis:5.0.1-alpine"
          image_pull_policy = "IfNotPresent"
          command           = ["/conf/update-node.sh", "redis-server", "/conf/redis.conf"]
          port {
            name           = "client"
            container_port = 6379
          }
          env {
            name = "POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }
          volume_mount {
            name       = "conf"
            mount_path = "/conf"
            read_only  = false
          }
          volume_mount {
            name       = "data"
            mount_path = "/data"
            read_only  = false
          }
        }

        termination_grace_period_seconds = 300

        volume {
          name = "conf"
          config_map {
            name         = "redis-cluster"
            default_mode = "0755"
          }
        }
      }
    }

    update_strategy {
      type = "RollingUpdate"

      rolling_update {
        partition = 1
      }
    }

    volume_claim_template {
      metadata {
        name      = "data"
        namespace = "${var.namespace}"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }
  }
}
