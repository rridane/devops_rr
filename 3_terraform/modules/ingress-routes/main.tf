locals {
  addPrefixKey   = "-add-prefix-"
  stripPrefixKey = "-strip-prefix-"
}

resource "kubernetes_manifest" "strip-prefix-middleware" {

  for_each = var.stripPrefixMiddlewares

  manifest = {

    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "${var.ingress_route.name}${local.stripPrefixKey}${each.key}"
      namespace = var.namespace
    }
    spec = {

      stripPrefix = {
        prefixes = [each.value.prefix]
      }

    }

  }
}

resource "kubernetes_manifest" "add-prefix-middleware" {

  for_each = var.addPrefixMiddleWares

  manifest = {

    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "${var.ingress_route.name}${local.addPrefixKey}${each.key}"
      namespace = var.namespace
    }

    spec = {

      addPrefix = {
        prefix = each.value.prefix
      }

    }

  }
}

resource "kubernetes_manifest" "ingress-route" {

  manifest = {

    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"

    metadata = {
      name      = var.ingress_route.name
      namespace = var.namespace
    }

    spec = {
      entryPoints = ["web"]
      routes = [
        {
          match = var.ingress_route.host != "" ? "Host(`${var.ingress_route.host}`) && PathPrefix(`${var.ingress_route.pathPrefix}`)" : "PathPrefix(`${var.ingress_route.pathPrefix}`)"
          kind  = "Rule"
          middlewares = flatten([[for key, middleware in var.addPrefixMiddleWares : {
            name : "${var.ingress_route.name}${local.addPrefixKey}${key}"
            }],
            [for key, middleware in var.stripPrefixMiddlewares : {
              name : "${var.ingress_route.name}${local.stripPrefixKey}${key}"
          }]])
          services = [{
            name = var.target-service.name
            port = var.target-service.port
            }
          ]
        }
      ]
    }

  }

}
