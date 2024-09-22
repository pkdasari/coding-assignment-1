aws_region           = "us-west-2"
s3_bucket_name       = "prod-terraform-state-bucket"
dynamodb_table_name  = "terraform-locks-prod"
key_name             = "prod-key"
tags = {
  Project     = "demo"
  Environment = "prod"
}
iam_role_name = "prod"
instance_profile_name = "prod"
whitelisted_ips = [ "10.2.0.1/32" ]



#EKS
region                    = "us-west-2"
environment               = "prod"
vpc_cidr                  = "10.2.0.0/16"
private_subnets_cidr      = ["10.2.3.0/24", "10.2.4.0/24"]
public_subnets_cidr       = ["10.2.1.0/24", "10.2.2.0/24"]
cluster_name              = "prod"
min_capacity              = 1
max_capacity              = 3
eks_release_version       = "v1.5"
instance_type             = "t3a.small"
cluster_version      = "1.30"