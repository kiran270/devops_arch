# DevOps Architecture - Terraform EKS Module

This repository contains a reusable Terraform module for provisioning AWS EKS clusters with managed node groups and a complete GitHub Actions CI/CD pipeline.

## Structure

```
devops_arch/
├── modules/
│   ├── ec2/              # EC2 module
│   └── eks/              # EKS cluster module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── usage/
│   ├── dev/              # Development environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── stage/            # Staging environment
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
└── .github/
    └── workflows/
        └── terraform.yml # CI/CD pipeline
```

## Usage

### 1. Configure Variables

Update `terraform.tfvars` in both dev and stage folders with your VPC subnet IDs:

```bash
# usage/dev/terraform.tfvars or usage/stage/terraform.tfvars
subnet_ids      = ["subnet-xxx", "subnet-yyy"]  # At least 2 subnets in different AZs
node_subnet_ids = ["subnet-xxx", "subnet-yyy"]  # Can be same as subnet_ids
```

### 2. Initialize and Apply Locally

```bash
# From the environment directory
cd usage/dev  # or usage/stage
terraform init
terraform plan
terraform apply
```

### 3. GitHub Actions Workflow

The workflow automatically:
- **Validates** Terraform on every push/PR
- **Plans** changes for both environments on push/PR  
- **Applies** only via manual approval (workflow_dispatch)

To deploy:
1. Go to Actions tab in GitHub
2. Select "Terraform CI/CD" workflow
3. Click "Run workflow"
4. Choose environment (dev or stage)
5. Approve in the environment protection rules

### 4. Required GitHub Secrets

Add these to your repository:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### 5. Connect to EKS Cluster

After provisioning:

```bash
aws eks update-kubeconfig --region us-east-1 --name eks-dev-cluster
kubectl get nodes
```

## EKS Module Features

- Managed EKS cluster with configurable Kubernetes version
- Managed node group with auto-scaling
- IAM roles and policies automatically configured
- Control plane logging enabled
- Public and private endpoint access options

## Module Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| cluster_name | EKS cluster name | string | - |
| kubernetes_version | Kubernetes version | string | 1.28 |
| subnet_ids | Subnets for cluster | list(string) | - |
| node_subnet_ids | Subnets for nodes | list(string) | - |
| desired_size | Desired nodes | number | 2 (dev), 3 (stage) |
| instance_types | Node instance types | list(string) | t3.medium (dev), t3.large (stage) |

## Module Outputs

- `cluster_name` - EKS cluster name
- `cluster_endpoint` - API server endpoint
- `cluster_arn` - Cluster ARN
- `node_group_id` - Node group ID

## Requirements

- Terraform >= 1.0
- AWS Provider ~> 5.0
- VPC with at least 2 subnets in different AZs
- Appropriate AWS IAM permissions
