aws_region = "us-east-1"

# VPC Configuration
vpc_name             = "eks-stage-vpc"
vpc_cidr             = "10.1.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
enable_nat_gateway   = true
single_nat_gateway   = false

# EKS Cluster Configuration
cluster_name            = "eks-stage-cluster"
kubernetes_version      = "1.28"
endpoint_private_access = true
endpoint_public_access  = true

# Node Group Configuration
node_group_name = "eks-stage-nodes"
desired_size    = 3
max_size        = 5
min_size        = 2
instance_types  = ["t3.large"]
disk_size       = 30

environment = "stage"
