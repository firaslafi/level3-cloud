terraform {
  required_providers {
    required_version = "~> 1.14.13"
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 3.4.0"
    }
  }
}

provider "openstack" {
  cloud       = "openstack"
}