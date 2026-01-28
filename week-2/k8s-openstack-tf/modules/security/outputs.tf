output "sg_name" {
  value = openstack_networking_secgroup_v2.k8s_sg.name
  description = "The name of the security group created for K8s cluster"
}

output "k8s_sg_id" {
  value = openstack_networking_secgroup_v2.k8s_sg.id
  description = "The ID of the security group created for K8s cluster"
}
