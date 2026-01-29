terraform {
  # Define and pin TF version
  required_version = "~> 1.14"
  required_providers {
    stackit = {
        # Choose the official registry source
        source  = "stackitcloud/stackit"
        # Define and pin provider version to avoid breaking changes
        version = "~> 0.79" 
    }
  }
}

# Provider configuration
provider "stackit" {
  # enable_beta_resources = true
}