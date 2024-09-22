output "aws_iam_role" {
  value       = aws_iam_role.eks_nodes.name
}

output "node_role_arn" {
  value       = aws_iam_instance_profile.eks_nodes.arn
}

# output "subnet_ids" {
#   value       = aws_eks_node_group.eks.subnet_ids
# }