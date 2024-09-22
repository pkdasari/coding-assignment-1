provider "aws" {
  region     = var.aws_region
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}

# locals {
#   account_id = var.aws_account_id
# }

# Call the backend module for S3 and DynamoDB
module "backend" {
  source              = "./modules/backend"
  s3_bucket_name      = var.s3_bucket_name
  dynamodb_table_name = var.dynamodb_table_name
  environment         = terraform.workspace
  tags                = merge(var.tags, { Environment = terraform.workspace })
}

# VPC module configuration
module "vpc" {
  source            = "./modules/vpc"
  cluster_name         = var.cluster_name
  environment          = var.environment
  private_subnets_cidr = var.private_subnets_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  region               = var.region
  vpc_cidr             = var.vpc_cidr
}

# Security Group module configuration
module "security_group" {
  source           = "./modules/security-group"
  vpc_id           = module.vpc.vpc_id
  whitelisted_ips  = var.whitelisted_ips
  ingress_from_port = var.ingress_from_port
  ingress_to_port  = var.ingress_to_port
  tags                  = merge(var.tags, { Environment = terraform.workspace })
}

# EKS module configuration
module "eks" {
  source = "./modules/eks"
  subnet_ids          = module.vpc.private_subnets_id
  vpc_id              = module.vpc.vpc_id
  cluster_name        = var.cluster_name
  cluster_version = var.cluster_version
  max_capacity        = var.max_capacity
  min_capacity        = var.min_capacity
  eks_release_version = var.eks_release_version
  instance_type       = var.instance_type
}


# IAM module configuration
module "iam" {
  source = "./modules/iam"
  role_name = var.iam_role_name
  policy_arn = var.policy_arn
  instance_profile_name = var.instance_profile_name
}
