# Eks

module "eks" {
  source              = "terraform-aws-modules/eks/aws"
  cluster_name        = var.cluster_name
  config_output_path  = "./${var.cluster_name}.yaml"
  cluster_version     = var.k8s_version
  subnets             = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  node_groups_defaults = {
    disk_size = var.disk_size
    ami_type  = "AL2_x86_64"
    key_name  = var.cluster_name
  }

  node_groups = var.node_groups
}

# # Rbac

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

resource "kubernetes_service_account" "devops" {
  metadata {
    name = "devops"
    namespace = "kube-system"
    labels = {
      "kubernetes.io/cluster-service" ="true"
      "addonmanager.kubernetes.io/mode" = "Reconcile"
      "cluster_id" = module.eks.cluster_id
    }
  }
}

resource "kubernetes_cluster_role_binding" "devops" {
  metadata {
    name = "devops"
    labels = {
      "cluster_id" = module.eks.cluster_id
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  
  subject {
    kind      = "ServiceAccount"
    name      = "devops"
    namespace = "kube-system"
  }
}

data "kubernetes_service_account" "devops" {
  metadata {
    name = "devops"
    namespace = "kube-system"
  }

  depends_on = [
    kubernetes_service_account.devops
  ]
}

data "kubernetes_secret" "devops" {
  metadata {
    name = data.kubernetes_service_account.devops.default_secret_name
  }

  depends_on = [
    kubernetes_service_account.devops
  ]
}
