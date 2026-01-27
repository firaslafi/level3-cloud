resource "openstack_compute_instance_v2" "master" {
  name            = "k8s-master"
  image_name      = var.image
  flavor_name     = var.master_flavor
  key_pair        = var.keypair
  security_groups = [var.secgroup_name]
  user_data       = file("scripts/install_k8s.sh")

  network {
    uuid = var.network_id
  }
}

resource "openstack_compute_instance_v2" "worker" {
  count           = var.worker_count
  name            = "k8s-worker-${count.index}"
  image_name      = var.image
  flavor_name     = var.worker_flavor
  key_pair        = var.keypair
  security_groups = [var.secgroup_name]
  user_data       = file("scripts/install_k8s.sh")

  network {
    uuid = var.network_id
  }
}