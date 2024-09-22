output "eks_security_group_id" {
  description = "The security group ID used by the EKS cluster"
  value       = aws_security_group.eks_sg.id
}
