aws_region           = "us-west-2"
s3_bucket_name       = "dev-terraform-state-bucket"
dynamodb_table_name  = "terraform-locks-dev"
key_name             = "dev-key"
tags = {
  Project     = "demo"
  Environment = "dev"
}
iam_role_name = "dev"
instance_profile_name = "dev"
whitelisted_ips = [ "10.0.0.1/32" ]



#EKS
region                    = "us-west-2"
environment               = "dev"
vpc_cidr                  = "10.0.0.0/16"
private_subnets_cidr      = ["10.0.3.0/24", "10.0.4.0/24"]
public_subnets_cidr       = ["10.0.1.0/24", "10.0.2.0/24"]
cluster_name              = "dev"
min_capacity              = 1
max_capacity              = 3
eks_release_version       = "v1.5"
instance_type             = "t3a.small"
cluster_version      = "1.30"