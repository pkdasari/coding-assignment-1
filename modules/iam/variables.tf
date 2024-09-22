variable "role_name" {
  description = "IAM Role name for EKS worker nodes"
  type        = string
}

variable "policy_arn" {
  description = "IAM Policy ARN for worker nodes"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

variable "instance_profile_name" {
  description = "Instance profile name for EKS worker nodes"
  type        = string
}
