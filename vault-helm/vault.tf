provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "vault" {
  #count     = data.terraform_remote_state.cluster.outputs.enable_consul_and_vault ? 1 : 0
  name      = "vault"
  #chart     = "${path.module}/vault-helm"
  chart     = "./vault-helm-chart"
  repository = "hashicorp/vault"
  #namespace = data.terraform_remote_state.consul.outputs.namespace

  set {
    name = "server.ha.enabled"
    value = "true"
  }

  set {
    name = "server.image.repository"
    value = "hashicorp/vault-enterprise"
  } 

  set {
    name = "server.image.tag"
    value = "1.7.3_ent"
  }

  set {
    name = "server.ha.enabled"
    value = "true"
  }

  set {
    name = "server.ha.raft.enabled"
    value = "true"
  }

}