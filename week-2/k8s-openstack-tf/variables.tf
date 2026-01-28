variable "image" {
    description = "The name of the image to use for the instances."
    type        = string
}

variable "master_flavor" {
    description = "The flavor to use for the master instance."
    type        = string
}

variable "worker_flavor" {
    description = "The flavor to use for the worker instances."
    type        = string
}

variable "keypair" {
    description = "The name of the key pair to use for SSH access."
    type        = string
}

variable "worker_count" {
    description = "The number of worker instances to create."
    type        = number
    default     = 2
}

variable "external_network_id" {
  type        = string
  description = "The UUID of the external/public network"
}
variable "external_network_name" {
  description = "The name of the external/public network"
  type        = string
}

variable "private_subnet_cidr" {
  default = "172.16.10.0/24"
  type        = string
  description = "The CIDR for the private subnet"
}

# variable "k8s_sg_id" {
#   type = string
#   description = "The ID of the security group created for K8s cluster"
# }
