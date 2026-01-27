resource "openstack_networking_secgroup_v2" "k8s_sg" {
  name = "k8s-security-group"
}

# Rule for API Server
resource "openstack_networking_secgroup_rule_v2" "api_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  security_group_id = openstack_networking_secgroup_v2.k8s_sg.id
}
# (Add more rules for etcd and Kubelet here)