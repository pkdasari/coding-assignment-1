
aws_region           = "us-west-2"
s3_bucket_name       = "staging-terraform-state-bucket"
dynamodb_table_name  = "terraform-locks-staging"
key_name             = "staging-key"
tags = {
  Project     = "demo"
  Environment = "staging"
}
iam_role_name = "staging"
instance_profile_name = "staging"
whitelisted_ips = [ "10.1.0.1/32" ]



#EKS
region                    = "us-west-2"
environment               = "staging"
vpc_cidr                  = "10.1.0.0/16"
private_subnets_cidr      = ["10.1.3.0/24", "10.1.4.0/24"]
public_subnets_cidr       = ["10.1.1.0/24", "10.1.2.0/24"]
cluster_name              = "staging"
min_capacity              = 1
max_capacity              = 3
eks_release_version       = "v1.5"
instance_type             = "t3a.small"
cluster_version      = "1.30"