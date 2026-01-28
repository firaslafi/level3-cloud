resource "openstack_networking_secgroup_v2" "k8s_sg" {
  name        = "k8s-security-group"
  description = "Allow K8s traffic"
}

# Allow SSH (Port 22) so you can log in
resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  security_group_id = openstack_networking_secgroup_v2.k8s_sg.id
}

# Allow K8s API (Port 6443)
resource "openstack_networking_secgroup_rule_v2" "k8s_api" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  security_group_id = openstack_networking_secgroup_v2.k8s_sg.id
}

# Allow ICMP (ping)
resource "openstack_networking_secgroup_rule_v2" "icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = openstack_networking_secgroup_v2.k8s_sg.id
}

# Allow Flannel VXLAN traffic (UDP port 8472)
resource "openstack_networking_secgroup_rule_v2" "flannel_vxlan" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8472
  port_range_max    = 8472
  security_group_id = openstack_networking_secgroup_v2.k8s_sg.id
}