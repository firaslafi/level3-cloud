terraform {
required_version = ">= 1.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4"
    }
  }
}

provider "openstack" {
  # Replace "openstack" with the name found in your clouds.yaml
  cloud = "openstack" 
}