output "sg_name" {
  value = openstack_networking_secgroup_v2.k8s_sg.name
  description = "The name of the security group created for K8s cluster"
}