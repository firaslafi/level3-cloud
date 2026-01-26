# Fetch the OS Image ID dynamically
data "stackit_image" "ubuntu" {
  project_id = var.project_id
  image_id = "33b2ffe4-73cc-4d2b-b406-215e66661a7a"
}

resource "stackit_key_pair" "keypair" {
  name       = "example-key-pair"
  public_key = chomp(file(pathexpand("~/.ssh/no-use.pub")))
}

resource "stackit_network_interface" "nic" {
  project_id         = var.project_id
  network_id         = var.network_id
  security_group_ids = ["ce018f42-f16f-43c4-8744-eed4f94207c8"]
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
    size                  = 20 # Disk size in GB
    delete_on_termination = true
  }

  # Network attachment
  network_interfaces = [stackit_network_interface.nic.network_interface_id]

  # Optional: Adds your SSH public key to the server
  # Ensure the key is already uploaded to the STACKIT portal
  keypair_name = stackit_key_pair.keypair.name
}