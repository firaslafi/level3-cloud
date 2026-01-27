# We need to export the Network ID so the Compute module can use it
output "network_id" {
  value = openstack_networking_network_v2.k8s_net.id
  description = "The ID of the private network created for K8s cluster"
}