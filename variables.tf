# variables.tf

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

# variable "aws_access_key" {
#   description = "AWS access key for the environment"
#   type        = string
# }

# variable "aws_secret_key" {
#   description = "AWS secret key for the environment"
#   type        = string
# }

# variable "aws_account_id" {
#   description = "AWS account ID for the environment"
#   type        = string
# }

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for storing Terraform state"
  type        = string
  default = "abc"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
  type        = string
  default = "abc"
}

variable "whitelisted_ips" {
  description = "List of IPs that are allowed access"
  type        = list(string)
}

variable "ingress_from_port" {
  description = "From port for ingress"
  type        = number
  default     = 80
}

variable "ingress_to_port" {
  description = "To port for ingress"
  type        = number
  default     = 80
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "key_name" {
  description = "Key pair for EC2 instances"
  type        = string
}


variable "iam_role_name" {
  description = "IAM role name for EKS worker nodes"
  type        = string
}

variable "policy_arn" {
  description = "IAM Policy ARN to attach to the role"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

variable "instance_profile_name" {
  description = "Name of the instance profile"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {
    Project     = "my-app"
  }
}


variable "region" {
  description = "Target Region"
}

variable "environment" {
  description = "The Deployment environment"
}

//Networking
variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the private subnet"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the public subnet"
}

variable "cluster_name" {
  default = "Name of eks cluster"
}

variable "min_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "instance_type" {}

variable "eks_release_version" {}
