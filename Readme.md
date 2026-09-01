# DevOps Architecture - Terraform EC2 Module

This repository contains a reusable Terraform module for provisioning AWS EC2 instances with a complete GitHub Actions CI/CD pipeline.

## Structure

```
devops_arch/
├── modules/
│   └── ec2/              # Reusable EC2 module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── usage/
│   ├── dev/              # Development environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars.example
│   └── stage/            # Staging environment
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars.example
└── .github/
    └── workflows/
        └── terraform.yml # CI/CD pipeline
```

## Usage

### 1. Configure Variables

Choose your environment (dev or stage) and configure:

```bash
# For development
cd usage/dev
cp terraform.tfvars.example terraform.tfvars

# For staging
cd usage/stage
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your AWS configuration.

### 2. Initialize and Apply

```bash
# From the environment directory
terraform init
terraform plan
terraform apply
```

### 3. GitHub Actions Setup

Add these secrets to your GitHub repository:

- `AWS_ACCESS_KEY_ID` - Your AWS access key
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret key

The workflow will:
- Validate Terraform code for both dev and stage on every push/PR
- Run `terraform plan` for both environments on pull requests
- Deploy to dev first, then stage on pushes to main branch
- Support manual deployment via workflow_dispatch

## Module Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| ami_id | AMI ID for EC2 instance | string | - |
| instance_type | EC2 instance type | string | t2.micro |
| subnet_id | Subnet ID | string | - |
| security_group_ids | Security group IDs | list(string) | [] |
| key_name | SSH key pair name | string | null |
| instance_name | Instance name tag | string | - |

## Module Outputs

- `instance_id` - EC2 instance ID
- `instance_public_ip` - Public IP address
- `instance_private_ip` - Private IP address

## Requirements

- Terraform >= 1.0
- AWS Provider ~> 5.0
- Valid AWS credentials with EC2 permissions
