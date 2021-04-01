terraform {
  required_version = ">= 0.12.0"
#   backend "s3" {
#     bucket = "terraform.company.env"
#     key    = "changeme/changeme/terraform.tfstate"
#     region = "ap-southeast-1"
#   }
}

module "eks" {
  source  = "./modules"

  region            = var.region
  # profile           = var.profile
  vpc_subnet        = var.vpc_subnet
  private_subnet    = var.private_subnet
  public_subnet     = var.public_subnet
  cluster_name      = var.cluster_name
  k8s_version       = var.k8s_version
  disk_size         = var.disk_size
  public_key        = var.public_key
  node_groups       = var.node_groups
}
