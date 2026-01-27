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

variable "secgroup_name" {
    description = "The name of the security group to associate with the instances."
    type        = string
}

variable "network_id" {
    description = "The ID of the network to attach the instances to."
    type        = string
}

variable "worker_count" {
    description = "The number of worker instances to create."
    type        = number
    default     = 2
}

variable "master_fip_address" {
  description = "The floating IP address to associate with the master instance."
  type        = string
}
variable "master_port_id" {
  description = "The port ID for the master instance."
  type        = string
}