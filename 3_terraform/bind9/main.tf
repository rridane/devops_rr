resource "kubernetes_deployment" "deployment" {

  metadata {
    name      = "bind9"
    namespace = "system"
    labels    = {
      app = "bind9"
    }
  }

  spec {

    selector {
      match_labels = {
        app = "bind9"
      }
    }

    template {

      metadata {
        labels = {
          app = "bind9"
        }
      }

      spec {
        container {
          name              = "bind9"
          image             = "ubuntu/bind9:edge"
          image_pull_policy = "Always"
          port {
            container_port = 53
            protocol = "UDP"
          }

          volume_mount {
            mount_path = "/etc/bind/named.conf.local"
            name       = "named-conf-local"
            sub_path = "named.conf.local"
          }

          volume_mount {
            mount_path = "/etc/bind/db.forward.com"
            name       = "db-forward-com"
            sub_path = "db.forward.com"
          }

          volume_mount {
            mount_path = "/etc/bind/named.conf.options"
            name       = "named-conf-options"
            sub_path = "named.conf.options"
          }

        }

        volume {

          name = "named-conf-local"

          config_map {

            name = "named-conf-local"

            items {
              key  = "CONF"
              path = "named.conf.local"
            }

          }

        }

        volume {

          name = "db-forward-com"

          config_map {

            name = "db-forward-com"

            items {
              key  = "CONF"
              path = "db.forward.com"
            }

          }

        }

        volume {

          name = "named-conf-options"

          config_map {

            name = "named-conf-options"

            items {
              key  = "CONF"
              path = "named.conf.options"
            }

          }

        }
      }
    }

  }

  depends_on = [kubernetes_config_map.named_conf_local]

}

  resource "kubernetes_service" "bind9" {

    metadata {
      name      = "bind9-svc"
      namespace = "system"
      labels    = {
        app = "bind9"
      }
    }

    spec {

      selector = {
        app = "bind9"
      }

      type = "NodePort"

      port {
        node_port = "32503"
        target_port = "53"
        port = "53"
        name        = "bind9"
        protocol = "UDP"
      }

    }

  }

  resource "kubernetes_config_map" "named_conf_local" {

    metadata {
      name      = "named-conf-local"
      namespace = "system"
    }

    data = {
      CONF = "${file("${path.cwd}/named.conf.local")}"
    }

  }

resource "kubernetes_config_map" "db_forward_com" {

  metadata {
    name      = "db-forward-com"
    namespace = "system"
  }

  data = {
    CONF = "${file("${path.cwd}/db.forward.com")}"
  }

}

resource "kubernetes_config_map" "named_conf_options" {

  metadata {
    name      = "named-conf-options"
    namespace = "system"
  }

  data = {
    CONF = "${file("${path.cwd}/named.conf.options")}"
  }

}
