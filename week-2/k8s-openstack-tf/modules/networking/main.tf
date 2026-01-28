resource "openstack_networking_network_v2" "k8s_net" {
  name = "k8s-internal"
}

resource "openstack_networking_subnet_v2" "k8s_subnet" {
  network_id = openstack_networking_network_v2.k8s_net.id
  cidr       = var.private_subnet_cidr
  ip_version = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "k8s_router" {
  name                = "k8s-router"
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "k8s_interface" {
  router_id = openstack_networking_router_v2.k8s_router.id
  subnet_id = openstack_networking_subnet_v2.k8s_subnet.id
}

resource "openstack_networking_port_v2" "master_port" {
  name         = "k8s-master-port"
  network_id   = openstack_networking_network_v2.k8s_net.id
  admin_state_up = "true"

  security_group_ids = [var.k8s_sg_id]

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.k8s_subnet.id
  }
}

resource "openstack_networking_floatingip_v2" "master_fip" {
  pool = var.external_network_name
}

resource "openstack_networking_floatingip_associate_v2" "master_fip" {
  floating_ip = openstack_networking_floatingip_v2.master_fip.address
  port_id     = openstack_networking_port_v2.master_port.id
  depends_on = [openstack_networking_router_interface_v2.k8s_interface]
}
