# StackIT Terraform Provider

This repository contains a Terraform provider for provisioning resources on StackIT cloud infrastructure.

## Usage

```hcl
terraform {
    required_providers {
        stackit = {
            source = "stackit/stackit"
        }
    }
}

provider "stackit" {
    # Configuration options
    default_region = "eu01"
}

resource "stackit_server" "example" {
    name       = "my-server"
    flavor     = "m1.medium"
    image      = "ubuntu-20.04"
    network_id = "your_network_id"  # Specify your network ID
    ssh_keys   = ["your_ssh_key_id"] # Add your SSH key ID for access
}
```

## Documentation

For detailed information, refer to the [STACKIT Terraform Provider
 documentation](https://registry.terraform.io/providers/stackitcloud/stackit/latest/docs).

