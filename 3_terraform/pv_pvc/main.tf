module "micro-service-volumes" {
  for_each = var.volumes
  source = "../modules/persistent-volumes"
  volume_name = each.key
  access_mode = each.value.mode
  namespace = each.value.namespace
  storage = each.value.storage
  storage_class_name = each.value.storage_class_name
  labels = each.value.labels
  nfs_server = var.nfs_server
  path = each.value.path
}
