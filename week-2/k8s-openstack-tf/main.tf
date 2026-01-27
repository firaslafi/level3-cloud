module "network" {
  source          = "./modules/networking"
  external_net_id = var.external_network_id
}

module "security" {
  source = "./modules/security"
}

module "compute" {
  source          = "./modules/compute"
  network_id      = module.network.network_id
  secgroup_name   = module.security.sg_name
  worker_count    = var.worker_count
  image           = var.image
  master_flavor   = var.master_flavor
  worker_flavor   = var.worker_flavor
  keypair         = var.keypair
}