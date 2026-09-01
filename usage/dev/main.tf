terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "helm" {
  kubernetes {
    host                   = module.eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  host                   = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_name]
    command     = "aws"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  cluster_name         = var.cluster_name

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "eks_cluster" {
  source = "../../modules/eks"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  subnet_ids         = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  node_subnet_ids    = module.vpc.public_subnet_ids

  cluster_security_group_ids = [module.vpc.eks_cluster_security_group_id]

  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access

  # Disable managed node group - using Karpenter instead
  create_node_group = false

  node_group_name = var.node_group_name
  desired_size    = var.desired_size
  max_size        = var.max_size
  min_size        = var.min_size
  instance_types  = var.instance_types
  disk_size       = var.disk_size

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  depends_on = [module.vpc]
}


module "karpenter" {
  source = "../../modules/karpenter"

  cluster_name       = var.cluster_name
  cluster_endpoint   = module.eks_cluster.cluster_endpoint
  cluster_arn        = module.eks_cluster.cluster_arn
  oidc_provider_arn  = module.eks_cluster.oidc_provider_arn
  node_iam_role_arn  = module.eks_cluster.node_iam_role_arn
  node_iam_role_name = module.eks_cluster.node_iam_role_name

  cpu_requests    = "500m"
  memory_requests = "1Gi"
  cpu_limits      = "2000m"
  memory_limits   = "4Gi"

  environment = var.environment

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  depends_on = [module.eks_cluster]
}
