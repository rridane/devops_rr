provider "kubernetes" {
  config_path    = "~/.kube/homelab/config"
  config_context = "kubernetes-admin@kubernetes"
}

terraform {
  backend "kubernetes" {
    secret_suffix = "routes-state"
    config_path   = "~/.kube/homelab/config"
    namespace     = "terraform"
  }
}

