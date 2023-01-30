module "routes" {
  source = "../modules/route_yaml_transfomer"
  yaml_file = "${path.cwd}/ingress_routes_by_applications.yaml"
}

module "ingress-routes" {
  source = "../modules/ingress-routes"
  for_each               = module.routes.routes
  stripPrefixMiddlewares = each.value["stripPrefixMiddlewares"]
  addPrefixMiddleWares   = each.value["addPrefixMiddlewares"]
  ingress_route          = each.value
  target-service = {
    name = each.value["target-service"]
    port = each.value["port"]
  }
  namespace = each.value["namespace"]
}

output "routes" {
  value = module.routes.routes
}