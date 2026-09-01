aws_region = "us-east-1"

# VPC Configuration
vpc_name             = "eks-dev-vpc"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
enable_nat_gateway   = true
single_nat_gateway   = true

# EKS Cluster Configuration
cluster_name            = "eks-dev-cluster"
kubernetes_version      = "1.28"
endpoint_private_access = true
endpoint_public_access  = true

# Node Group Configuration - Optimized for account limits
node_group_name = "eks-dev-nodes"
desired_size    = 1        # Reduced to 1 node to fit limits
max_size        = 2        # Max 2 nodes
min_size        = 1        # Min 1 node
instance_types  = ["t3.small"]  # t3.small has 2 vCPU (2000m), 2GB RAM
disk_size       = 20

environment = "dev"
