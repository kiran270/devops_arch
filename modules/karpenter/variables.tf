variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_arn" {
  description = "ARN of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  type        = string
}

variable "node_iam_role_arn" {
  description = "ARN of the node IAM role"
  type        = string
}

variable "node_iam_role_name" {
  description = "Name of the node IAM role"
  type        = string
}

variable "karpenter_version" {
  description = "Version of Karpenter to install"
  type        = string
  default     = "v0.33.0"
}

variable "cpu_requests" {
  description = "CPU requests for node pool"
  type        = string
  default     = "500m"
}

variable "memory_requests" {
  description = "Memory requests for node pool"
  type        = string
  default     = "1Gi"
}

variable "cpu_limits" {
  description = "CPU limits for cluster"
  type        = string
  default     = "2000m"
}

variable "memory_limits" {
  description = "Memory limits for cluster"
  type        = string
  default     = "4Gi"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
