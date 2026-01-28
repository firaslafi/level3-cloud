
## Network related 
# Create network
resource "openstack_networking_network_v2" "test_net" {
  name           = "terraform-test-network"
  admin_state_up = "true"
}
# Create the subnet
resource "openstack_networking_subnet_v2" "test_subnet" {
  name = "${openstack_networking_network_v2.test_net.name}-subnet"
  network_id = openstack_networking_network_v2.test_net.id
  ip_version = 4
  cidr = "10.10.0.0/24"

  allocation_pool {
    start = "10.10.0.10"
    end = "10.10.0.200"
  } 
  # to communicate with internt
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

## Instance related
# Image
data "openstack_images_image_v2" "cirros" {
    name = "cirros-0.6.3-x86_64-disk"
    most_recent = true
}

# Instance
resource "openstack_compute_instance_v2" "web-server" {
  name = "terraform-vm-example"
  image_id = data.openstack_images_image_v2.cirros.id
  flavor_name = "cirros256"
  security_groups = [ "default", "SSH" ]

  network {
    uuid = openstack_networking_network_v2.test_net.id
  }

  metadata = {
    demo = "terraform"
  }
}