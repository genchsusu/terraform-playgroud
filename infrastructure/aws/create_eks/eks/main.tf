terraform {
  required_version = ">= 0.12.0"
  required_providers {
    random = {
      version = "~> 2.1"
    }
    local = {
      version = "~> 1.2"
    }
    null = {
      version = "~> 2.1"
    }
    template = {
      version = "~> 2.1"
    }
    kubernetes = {
      version = "~> 1.11"
    }
  }
  backend "s3" {
    bucket = "changeme"
    key    = "changeme/changeme/terraform.tfstate"
    region = "ap-southeast-1"
    profile = "fat"
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

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

data "aws_availability_zones" "available" {
}

locals {
  # cluster_name = "fat-eks-${random_string.suffix.result}"
  cluster_name = "fat-eks-qH78EzN0"
}

# resource "random_string" "suffix" {
#   length  = 8
#   special = false
# }

resource "aws_key_pair" "deployer" {
  key_name   = local.cluster_name
  public_key = var.ec2-key-public-key
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.47.0"

  name                 = "fat-eks-vpc"
  cidr                 = "10.1.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets       = ["10.1.253.0/24", "10.1.254.0/24", "10.1.255.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

module "eks" {
  source              = "terraform-aws-modules/eks/aws"
  cluster_name        = local.cluster_name
  config_output_path  = "./output/${local.cluster_name}.yaml"
  cluster_version     = "1.19"
  subnets             = module.vpc.private_subnets

  tags = {
    Environment = "fat"
  }

  vpc_id = module.vpc.vpc_id

  node_groups_defaults = {
    disk_size = 100
    ami_type  = "AL2_x86_64"
    key_name  = local.cluster_name
  }

  node_groups = {
    worker = {
      desired_capacity  = 3
      instance_types    = ["m5.xlarge"]

      max_capacity      = 5
      min_capacity      = 1
    }
    utilities = {
      desired_capacity  = 3
      instance_types    = ["m5.xlarge"]

      max_capacity      = 5
      min_capacity      = 1

      k8s_labels = {
        utilities = "true"
      }
    }
  }
}