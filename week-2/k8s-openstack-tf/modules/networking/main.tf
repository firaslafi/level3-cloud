resource "openstack_networking_network_v2" "k8s_net" {
  name = "k8s-internal"
}

resource "openstack_networking_subnet_v2" "k8s_subnet" {
  network_id = openstack_networking_network_v2.k8s_net.id
  cidr       = "192.168.10.0/24"
  ip_version = 4
}

resource "openstack_networking_router_v2" "k8s_router" {
  name                = "k8s-router"
  external_network_id = var.external_net_id
}

resource "openstack_networking_router_interface_v2" "k8s_interface" {
  router_id = openstack_networking_router_v2.k8s_router.id
  subnet_id = openstack_networking_subnet_v2.k8s_subnet.id
}
