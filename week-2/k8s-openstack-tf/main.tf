module "network" {
  source          = "./modules/networking"
  external_net_id = "your-external-net-uuid"
}

module "security" {
  source = "./modules/security"
}

module "compute" {
  source          = "./modules/compute"
  network_id      = module.network.network_id
  secgroup_name   = module.security.secgroup_name
  worker_count    = 2
  image           = "Ubuntu 24.04"
  master_flavor   = "m1.medium"
  worker_flavor   = "m1.small"
  keypair         = "my-ssh-key"
}