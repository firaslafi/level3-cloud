module "network" {
  source                = "./modules/networking"
  external_network_id   = var.external_network_id
  external_network_name = var.external_network_name
  private_subnet_cidr   = var.private_subnet_cidr
  k8s_sg_id             = module.security.k8s_sg_id
}

module "security" {
  source = "./modules/security"
}

module "compute" {
  source             = "./modules/compute"
  network_id         = module.network.network_id
  master_port_id     = module.network.master_port_id
  master_fip_address = module.network.master_fip
  secgroup_name      = module.security.sg_name
  k8s_sg_id          = module.security.k8s_sg_id
  worker_count       = var.worker_count
  image              = var.image
  master_flavor      = var.master_flavor
  worker_flavor      = var.worker_flavor
  keypair            = var.keypair
}

output "master_fip" {
  description = "The floating IP address of the master node."
  value       = module.network.master_fip
}