terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.2"
    }
  }

  #required_version = "=> 0.14"
}


#provider "kubernetes" {
#  host                   = data.terraform_remote_state.cluster.outputs.host
#  token                  = data.google_client_config.default.access_token
#  cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.cluster_ca_certificate
#
##}

#provider "helm" {
#  kubernetes {
#    host                   = data.terraform_remote_state.cluster.outputs.host
#    token                  = data.google_client_config.default.access_token
#    cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.cluster_ca_certificate
#  }
#}
