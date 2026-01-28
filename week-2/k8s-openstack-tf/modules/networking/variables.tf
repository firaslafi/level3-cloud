variable "external_network_id" {
  type        = string
  description = "The UUID of the external/public network"
}
variable "external_network_name" {
  type = string
  description = "The name of the external/public network"
}

variable "private_subnet_cidr" {
  type = string
  description = "The CIDR for the internal Kubernetes network"
}

variable "k8s_sg_id" {
  type = string
  description = "The ID of the security group to associate with the ports"
}