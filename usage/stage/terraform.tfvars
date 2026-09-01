aws_region = "us-east-1"

# VPC Configuration
vpc_name             = "eks-stage-vpc"
vpc_cidr             = "10.1.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
enable_nat_gateway   = false  # Set to false to skip NAT Gateway (saves ~$64/month)
single_nat_gateway   = false

# EKS Cluster Configuration
cluster_name            = "eks-stage-cluster"
kubernetes_version      = "1.28"
endpoint_private_access = true
endpoint_public_access  = true

# Node Group Configuration - Optimized for account limits
node_group_name = "eks-stage-nodes"
desired_size    = 2
max_size        = 2
min_size        = 1
instance_types  = ["t3.small"]
disk_size       = 20

environment = "stage"
