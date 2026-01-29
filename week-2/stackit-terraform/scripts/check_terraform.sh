#!/usr/bin/env bash
set -euo pipefail

# ------------------------------
# check_terraform.sh
# ------------------------------
# Checks if Terraform is installed.
# If not, installs it (brew on macOS, manual download on Linux).
# ------------------------------

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# Normalize architecture
case "$ARCH" in
    x86_64|amd64) ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    *) echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Check if Terraform is already installed
if command_exists terraform; then
    echo "✅ Terraform is already installed: $(terraform version | head -n1)"
    return 0 2>/dev/null || exit 0
fi

echo "⚡ Terraform not found. Installing..."

if [[ "$OS" == "darwin" ]]; then
    # macOS: install via Homebrew
    if ! command_exists brew; then
        echo "❌ Homebrew not found. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi
    echo "⬇️ Installing Terraform via Homebrew..."
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
else
    # Linux / other: install manually
    echo "⬇️ Downloading Terraform for $OS/$ARCH..."

    LATEST=$(curl -s https://releases.hashicorp.com/terraform/index.json | \
             jq -r '.versions | keys | last')

    if [[ -z "$LATEST" ]]; then
        echo "❌ Could not fetch latest Terraform version" >&2
        exit 1
    fi

    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"

    curl -sLO "https://releases.hashicorp.com/terraform/${LATEST}/terraform_${LATEST}_${OS}_${ARCH}.zip"
    unzip -q "terraform_${LATEST}_${OS}_${ARCH}.zip"

    if [[ ! -x terraform ]]; then
        echo "❌ Terraform binary not found after unzip" >&2
        exit 1
    fi

    echo "⬆️ Installing Terraform to /usr/local/bin (sudo required)"
    sudo mv terraform /usr/local/bin/
    sudo chmod +x /usr/local/bin/terraform

    cd -
    rm -rf "$TMP_DIR"
fi

# Verify installation
echo "✅ Terraform installed successfully: $(terraform version | head -n1)"
