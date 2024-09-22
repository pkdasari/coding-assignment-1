data "aws_availability_zones" "available" {}



data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

locals {
  cluster_name = var.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

#module "eks-kubeconfig" {
#  source  = "hyperbadger/eks-kubeconfig/aws"
#  version = "2.0.0"
#
#  depends_on   = [module.eks]
#  cluster_name = module.eks.cluster_name
#}
#
#resource "local_file" "kubeconfig" {
#  content  = module.eks-kubeconfig.kubeconfig
#  filename = "kubeconfig_${local.cluster_name}"
#}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.2"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.subnet_ids

  vpc_id = var.vpc_id
  eks_managed_node_groups = {
    worker = {
      min_size     = var.min_capacity
      max_size     = var.max_capacity
      desired_size = var.min_capacity

      instance_types = [var.instance_type]

      tags = {
        ExtraTag = "EKS managed node group complete setup"
      }
    }
  }
  tags = {
    version = var.eks_release_version
    Name    = var.cluster_name
  }
}