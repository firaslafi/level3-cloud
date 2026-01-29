#!/usr/bin/env bash

# stackit_auth_key.sh
# -------------------
# This script authenticates with STACKIT using a service account key, sets the project,
# and resolves the image ID for a specified Ubuntu image (non-ARM). It exports the image ID
# as an environment variable for use with Terraform (TF_VAR_image_id).
# exports the service account key for use with Terraform as well.
#
# Usage:
#   source ./scripts/stackit_auth_key.sh
#
# Requirements:
#   - The STACKIT CLI must be installed and available in your PATH.
#   - The service account key file must exist at $HOME/sa-key.json.
#   - The PROJECT_ID and IMAGE_NAME variables should be set as needed.

# Clear RPROMPT to avoid interference for zsh users
export RPROMPT="${RPROMPT-}"

# Exit immediately if a command exits with a non-zero status, treat unset variables as errors, and fail if any command in a pipeline fails
set -euo pipefail

# ========= Configuration =========
# STACKIT project ID to use for authentication and resource management
PROJECT_ID="a7cab4a8-6c1c-4855-a93c-caaec314b151"
# Path to the STACKIT service account key JSON file
KEY_PATH="$HOME/sa-key.json"
# Name of the Ubuntu image to resolve (non-ARM)
IMAGE_NAME="Ubuntu 24.04"
# =================================

echo "🔐 Loading STACKIT service account key..."

# Check if the service account key file exists
if [[ ! -f "$KEY_PATH" ]]; then
  echo "❌ Service account key not found: $KEY_PATH" >&2
  exit 1
fi

# Export the service account key as an environment variable for the STACKIT CLI and Terraform
export STACKIT_SERVICE_ACCOUNT_KEY
STACKIT_SERVICE_ACCOUNT_KEY="$(<"$KEY_PATH")"

# Authenticate with STACKIT using the service account key
stackit auth activate-service-account >/dev/null

echo "📦 Setting STACKIT project: $PROJECT_ID"
# Set the active STACKIT project
stackit config set --project-id "$PROJECT_ID" >/dev/null

# Export the project ID for Terraform
export TF_VAR_project_id="$PROJECT_ID"

echo "🖼️  Resolving image ID for: $IMAGE_NAME (non-ARM)"

# Query STACKIT for the image ID matching the specified image name, excluding ARM64 images
TF_VAR_image_id="$(
  stackit image list --output-format pretty \
  | grep "$IMAGE_NAME" \
  | grep -v ARM64 \
  | awk '{print $1}'
)"

# Check if the image ID was found
if [[ -z "$TF_VAR_image_id" ]]; then
  echo "❌ Failed to resolve image ID for $IMAGE_NAME (non-ARM)" >&2
  exit 1
fi

# Export the image ID as a Terraform variable
export TF_VAR_image_id

echo "✅ Image ID resolved: $TF_VAR_image_id"

