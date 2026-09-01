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
