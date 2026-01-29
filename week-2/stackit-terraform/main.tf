# Fetch the OS Image ID dynamically
data "stackit_image" "ubuntu" {
  project_id = var.project_id
  image_id = var.image_id
}

resource "stackit_key_pair" "keypair" {
  name       = "no-use"
  public_key = chomp(file(pathexpand("~/.ssh/no-use.pub")))
}

resource "stackit_network_interface" "nic" {
  project_id         = var.project_id
  network_id         = var.network_id
  security_group_ids = ["ce018f42-f16f-43c4-8744-eed4f94207c8"]
}


# Associate the Public IP with the Network Interface
resource "stackit_public_ip_associate" "link_ip" {
  project_id           = var.project_id
  public_ip_id         = "7ca7a0ab-008c-4316-9df9-43764b1c4d59"
  network_interface_id = stackit_network_interface.nic.network_interface_id
}

# Provision the Server
resource "stackit_server" "example_server" {
  project_id   = var.project_id
  name         = var.instance_name
  machine_type = var.machine_type

  # Boot volume configuration
  boot_volume = {
    source_type           = "image"
    source_id             = data.stackit_image.ubuntu.image_id
    size                  = 100 # Disk size in GB
    delete_on_termination = true
  }

  # Network attachment
  network_interfaces = [stackit_network_interface.nic.network_interface_id]

  # Adds your SSH public key to the server
  keypair_name = stackit_key_pair.keypair.name
}