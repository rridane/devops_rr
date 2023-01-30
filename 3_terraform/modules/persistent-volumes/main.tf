variable "volume_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "labels" {
  type = map(string)
}

variable "access_mode" {
  type = string
}

variable "storage_class_name" {
  type = string
  default = ""
}

variable "storage" {
  type = string
}

variable "nfs_server" {
  type = string
}

variable "path" {
  type = string
}

resource "kubernetes_persistent_volume_claim" "pvc" {

  metadata {
    name = "${var.namespace}-${var.volume_name}"
    namespace = var.namespace
    labels = var.labels
  }

  spec {
    access_modes = [var.access_mode]
    volume_name = "${var.namespace}-${var.volume_name}"
    storage_class_name = var.storage_class_name
    resources {
      requests = {
        storage = var.storage
      }
    }
  }

}

resource "kubernetes_persistent_volume" "pv" {

  metadata {
    name = "${var.namespace}-${var.volume_name}"
    labels = var.labels
  }

  spec {

    access_modes = [var.access_mode]

    capacity     = {
        storage = var.storage
    }

    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        path   = var.path
        server = var.nfs_server
      }
    }
  }

}
