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

## Authentication

StackIT Terraform Provider uses **Key Flow** authentication with an API key.

### Key Flow

This method uses an API key for authentication.

**Recommended: Use a Terraform variable for your API key**
```hcl
variable "stackit_api_key" {
  description = "StackIT API key"
  type        = string
  sensitive   = true
}

provider "stackit" {
  authentication = {
    type    = "key_flow"
    api_key = var.stackit_api_key
  }
  default_region = "eu01"
}
```
- Pass the API key securely using a `terraform.tfvars` file or via environment variable:
  ```sh
  export TF_VAR_stackit_api_key="your_api_key"
  ```

**Alternative: Direct environment variable**
```sh
export STACKIT_API_KEY="your_api_key"
```
If set, the provider will automatically use this value.

#### Additional Notes

- If both provider block values and environment variables are set, provider block values take precedence.
- Ensure your API key has sufficient permissions for the resources you want to manage.
- Never commit your credentials to version control.

#### Troubleshooting

- If authentication fails, double-check your API key and region.
- Ensure your API key is active and has not expired.
- For more help, enable debug logging with:
  ```sh
  export TF_LOG=DEBUG
  ```

## Documentation

For detailed information, refer to the [STACKIT Terraform Provider
 documentation](https://registry.terraform.io/providers/stackitcloud/stackit/latest/docs).

