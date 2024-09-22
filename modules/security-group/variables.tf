variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "whitelisted_ips" {
  description = "List of whitelisted IPs for accessing the application"
  type        = list(string)
}

variable "ingress_from_port" {
  description = "From port for ingress"
  type        = number
}

variable "ingress_to_port" {
  description = "To port for ingress"
  type        = number
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}
