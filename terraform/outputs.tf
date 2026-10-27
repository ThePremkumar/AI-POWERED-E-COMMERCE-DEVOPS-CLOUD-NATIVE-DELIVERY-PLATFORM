# =============================================================================
# outputs.tf – Terraform outputs
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================

output "app_server_public_ip" {
  description = "Public IP of the application server"
  value       = module.app_server.public_ip
}

output "app_server_dns" {
  description = "Public DNS of the application server"
  value       = module.app_server.public_dns
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.endpoint
  sensitive   = true
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
