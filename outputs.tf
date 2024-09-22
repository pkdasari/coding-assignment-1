output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.vpc_id
}

# output "public_subnets" {
#   description = "The IDs of the public subnets"
#   value       = module.vpc.public_subnets
# }

# output "eks_cluster_id" {
#   description = "The ID of the EKS cluster"
#   value       = module.eks.eks_cluster_id
# }

# output "eks_cluster_endpoint" {
#   description = "The endpoint of the EKS cluster"
#   value       = module.eks.eks_cluster_endpoint
# }

output "eks_security_group_id" {
  description = "The security group ID for the EKS cluster"
  value       = module.security_group.eks_security_group_id
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket used for backend state storage"
  value       = module.backend.s3_bucket_name
}
