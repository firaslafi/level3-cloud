variable "project_id" {
  type        = string
  description = "The UUID of your STACKIT project."
}

variable "region" {
  type        = string
  default     = "eu01"
  description = "The STACKIT region where resources will be created."
}

variable "instance_name" {
  type        = string
  default     = "stackit-server-01"
  description = "The name of the virtual machine."
}

variable "network_id" {
  type        = string
  description = "The ID of the network (VPC) where the server will live."
}

variable "machine_type" {
  type        = string
  default     = "g1a.1d"
  description = "The flavor/size of the server."
}

variable "image_id" {
  type        = string
  description = "The STACKIT Ubuntu 24.04 image ID (non-ARM)"
}