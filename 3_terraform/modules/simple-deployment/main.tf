variable "deploy" {

  type = object({
    namespace  = string
    name       = string
    labels     = map(string)
    replicas   = number
    image      = string
    command    = string
    entrypoint = string
    args       = list(string)
    volumes    = map(string)
  })

}

locals {
  labels = merge(
    var.deploy.labels,
    {
      release_date : formatdate("DD-MM-YYYY__hh-mm", timestamp()),
    }
  )
}

resource "kubernetes_deployment" "simple-deploy" {

  metadata {
    name      = var.deploy.name
    namespace = var.deploy.namespace
  }

  spec {
    replicas = var.deploy.replicas

    selector {
      match_labels = local.labels
    }

    template {

      metadata {
        labels = local.labels
      }

      spec {

        image_pull_secrets {
          name = "regcred"
        }

        container {
          name              = var.deploy.name
          image             = var.deploy.image
          image_pull_policy = "Always"
          command           = var.deploy.command != "" ? [var.deploy.command] : null
          args              = var.deploy.args

          env {
            name  = "TZ"
            value = "Europe/Paris"
          }

          port {
            container_port = 8080
          }

          dynamic "volume_mount" {
            for_each = var.deploy.volumes
            content {
              mount_path = volume_mount.value
              name       = "${var.deploy.namespace}-${volume_mount.key}"
            }
          }

          #          readiness_probe {
          #            tcp_socket {
          #              port = "8080"
          #            }
          #            initial_delay_seconds = 10
          #            period_seconds        = 15
          #            failure_threshold     = 30
          #          }
          #
          #          startup_probe {
          #            tcp_socket {
          #              port = "8080"
          #            }
          #            initial_delay_seconds = 180
          #            period_seconds        = 15
          #            failure_threshold     = 30
          #          }
          #
          #          dynamic "liveness_probe" {
          #
          #            for_each = var.deploy.http_liveness_probe
          #
          #            content {
          #              http_get {
          #                path = liveness_probe.value.endpoint
          #                port = "8080"
          #              }
          #              initial_delay_seconds = 10
          #              period_seconds        = 30
          #              failure_threshold     = 1
          #            }
          #
          #          }

          #          resources {
          #
          #            limits = {
          #              cpu    = var.container.cpu_limit
          #              memory = var.container.memory_limit
          #            }
          #
          #            requests = {
          #              cpu    = var.container.cpu_request
          #              memory = var.container.memory_request
          #            }
          #
          #          }
          #
          #        }

          #        dynamic "init_container" {
          #          for_each = var.container.init_container
          #          content {
          #            name  = init_container.value
          #            image = "curlimages/curl:latest"
          #            command = [
          #              "sh",
          #              "-c",
          #              "while [ `curl -Lk --write-out '%%{http_code}\n' --silent --output /dev/null 'http://${init_container.value}-svc:8080'` -ne '401' ]; do echo 'waiting' && sleep 2; done"
          #            ]
          #          }
          #        }
          #
          #        dynamic "volume" {
          #          for_each = var.deploy.volumes
          #          content {
          #            name = "${var.deploy.namespace}-${volume.key}"
          #            persistent_volume_claim {
          #              claim_name = "${var.deploy.namespace}-${volume.key}"
          #            }
          #          }
          #        }

          #      }

        }
      }

    }
  }
}

#output "micro-service-deploy-name" {
#  value = kubernetes_deployment.micro-service-deploy.metadata[0].name
#}
#
#output "micro-service-svc-name" {
#  value = kubernetes_service.micro-service-svc.metadata[0].name
#}
#
#resource "kubernetes_service" "micro-service-svc" {
#
#  metadata {
#    name      = "${var.deploy.name}-svc"
#    namespace = var.deploy.namespace
#    labels    = local.labels
#  }
#
#  spec {
#
#    selector = local.labels
#
#    port {
#      port        = var.deploy.service_port
#      target_port = var.container.container_port
#    }
#
#  }
#
#}
#
#resource "kubernetes_manifest" "micro-service-hpa" {
#
#  count = length(var.deploy.hpa) > 0 ? 1 : 0
#
#  manifest = {
#
#    apiVersion = "autoscaling/v2beta2"
#    kind       = "HorizontalPodAutoscaler"
#
#    metadata = {
#      name      = var.deploy.name
#      namespace = var.deploy.namespace
#    }
#
#    spec = {
#      minReplicas = var.deploy.hpa.spec.min_replicas
#      maxReplicas = var.deploy.hpa.spec.max_replicas
#      scaleTargetRef = {
#        apiVersion = "apps/v1"
#        kind       = "Deployment"
#        name       = var.deploy.name
#      }
#      metrics = [
#        {
#          type = "Resource"
#          resource = {
#            name = "memory"
#            target = {
#              type               = "Utilization"
#              averageUtilization = var.deploy.hpa.spec.memory_average_utilization
#            }
#          }
#        },
#        {
#          type = "Resource"
#          resource = {
#            name = "cpu"
#            target = {
#              type               = "Utilization"
#              averageUtilization = var.deploy.hpa.spec.cpu_average_utilization
#            }
#          }
#        }
#      ]
#      behavior = {
#        scaleDown = {
#          stabilizationWindowSeconds = var.deploy.hpa.scale_down.period
#          policies = [
#            {
#              periodSeconds = var.deploy.hpa.scale_down.period
#              type          = var.deploy.hpa.scale_down.type
#              value         = var.deploy.hpa.scale_down.value
#            },
#          ]
#        }
#        scaleUp = {
#          stabilizationWindowSeconds = var.deploy.hpa.scale_up.period
#          policies = [
#            {
#              periodSeconds = var.deploy.hpa.scale_up.period
#              type          = var.deploy.hpa.scale_up.type
#              value         = var.deploy.hpa.scale_up.value
#            },
#          ]
#        }
#      }
#    }
#
#  }
#}
