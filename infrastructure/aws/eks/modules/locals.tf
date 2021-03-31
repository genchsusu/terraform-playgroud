locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)}
    server: ${module.eks.cluster_endpoint}
  name: ${var.cluster-name}
contexts:
- context:
    cluster: ${var.cluster-name}
    namespace: default
    user: admin
  name: ${var.cluster-name}
current-context: ${var.cluster-name}
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: ${base64decode(data.kubernetes_secret.devops.data.token)}
KUBECONFIG
}