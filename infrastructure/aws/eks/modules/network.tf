data "aws_availability_zones" "available" {
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.47.0"

  name                 = "${var.cluster_name}-vpc"
  cidr                 = var.vpc_subnet
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnet
  public_subnets       = var.public_subnet
  enable_nat_gateway   = true
  single_nat_gateway   = true
  # enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}