locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)}
    server: ${module.eks.cluster_endpoint}
  name: ${var.cluster_name}
contexts:
- context:
    cluster: ${var.cluster_name}
    namespace: default
    user: admin
  name: ${var.cluster_name}
current-context: ${var.cluster_name}
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: 
KUBECONFIG
}
