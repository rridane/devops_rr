variable "volumes" {
  type = map(object({
    namespace = string
    labels = map(string)
    mode = string
    storage = string
    storage_class_name = optional(string)
    path = string
  }))
  default = {
    nextcloud = {
      namespace = "nextcloud"
      labels = {}
      mode: "ReadWriteMany"
      storage: "10Ti"
      path = "/mnt/storage/nextcloud"
    }
    nextcloud-postgres = {
      namespace = "nextcloud"
      labels = {}
      mode: "ReadWriteMany"
      storage: "2Gi"
      path = "/mnt/data/kube_data/nextcloud_postgres"
    }
    harbor  = {
      namespace = "system"
      labels = {}
      mode: "ReadWriteMany"
      storage: "2Gi"
      path = "/mnt/data/kube_data/harbor"
    }
  }
}

variable "nfs_server" {
  type = string
  default = "10.10.10.109"
}