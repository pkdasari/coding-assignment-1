variable "subnet_ids" {
}

variable "cluster_name" {
  description = "Name of eks cluster"
}

variable "vpc_id" {}


variable "min_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "instance_type" {}

variable "eks_release_version" {}

variable "cluster_version" {}