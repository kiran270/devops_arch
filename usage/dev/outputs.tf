output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks_cluster.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS cluster"
  value       = module.eks_cluster.cluster_endpoint
}

output "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks_cluster.cluster_arn
}

output "eks_node_group_id" {
  description = "ID of the EKS node group"
  value       = module.eks_cluster.node_group_id
}

output "eks_cluster_security_group_id" {
  description = "Security group ID of the EKS cluster"
  value       = module.vpc.eks_cluster_security_group_id
}

output "eks_nodes_security_group_id" {
  description = "Security group ID of the EKS nodes"
  value       = module.vpc.eks_nodes_security_group_id
}


output "coolify_instance_id" {
  description = "ID of the Coolify EC2 instance"
  value       = module.coolify.instance_id
}

output "coolify_public_ip" {
  description = "Public IP of Coolify server"
  value       = module.coolify.public_ip
}

output "coolify_dashboard_url" {
  description = "Coolify dashboard URL"
  value       = module.coolify.coolify_url
}

output "coolify_ssh_command" {
  description = "SSH command to connect to Coolify server"
  value       = module.coolify.ssh_command
}
