provider "kubernetes" {

  config_path    = "~/.kube/homelab/config"
  config_context = "kubernetes-admin@kubernetes"
}

#terraform {
#  backend "kubernetes" {
#    secret_suffix = "dns-state"
#    config_path   = "~/.kube/homelab/config"
#    namespace     = "terraform"
#  }
#  experiments = [module_variable_optional_attrs]
#}

terraform {
  cloud {
    organization = "rridane"

    workspaces {
      name = "dns-state"
    }
  }
}