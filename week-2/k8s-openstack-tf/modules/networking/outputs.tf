# We need to export the Network ID so the Compute module can use it
output "network_id" {
  value = openstack_networking_network_v2.k8s_net.id
  description = "The ID of the private network created for K8s cluster"
}

output "master_port_id" {
  value = openstack_networking_port_v2.master_port.id
  description = "Master port id"
}
output "master_fip" {
  value = openstack_networking_floatingip_v2.master_fip.address
  description = "The floating IP address assigned to the K8s master node"
}