output "cluster_name" {
  value = local.cluster_name
}
output "endpoint" {
  value = module.eks.cluster_endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_eni_sg_id" {
  value = module.eks.cluster_primary_security_group_id
}