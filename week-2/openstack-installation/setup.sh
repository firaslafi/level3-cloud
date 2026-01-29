#!/bin/bash

# Ensure the script is run with sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo)."
   exit 1
fi

# 1. Prompt for the secret password
read -s -p "Enter the ADMIN_PASSWORD: " ADMIN_PASS
echo ""

# 2. Create the stack user and set permissions
echo "Creating 'stack' user..."
useradd -s /bin/bash -d /opt/stack -m stack
chmod +x /opt/stack

# 3. Add stack user to sudoers
echo "Configuring sudoers for 'stack'..."
echo "stack ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/stack

# 4. Perform setup as the 'stack' user
sudo -u stack bash <<EOF
cd /opt/stack

echo "Cloning DevStack..."
git clone https://opendev.org/openstack/devstack
cd devstack
git checkout stable/2025.2

echo "Downloading local.conf..."
wget -q https://raw.githubusercontent.com/firaslafi/level3-cloud/main/week-2/openstack-installation/local.conf -O local.conf

echo "Creating secrets file and enabling auto-source..."
cat <<SECRETS > /opt/stack/openstack_secrets
export ADMIN_PASSWORD=$ADMIN_PASS
export DATABASE_PASSWORD=$ADMIN_PASS
export RABBIT_PASSWORD=$ADMIN_PASS
export SERVICE_PASSWORD=$ADMIN_PASS
SECRETS

# Append to .bashrc for automatic sourcing
if ! grep -q "source /opt/stack/openstack_secrets" /opt/stack/.bashrc; then
    echo "source /opt/stack/openstack_secrets" >> /opt/stack/.bashrc
fi
EOF

echo "---"
echo "Setup complete! Switching to 'stack' user now..."
echo "---"

# 5. Hand over control to the stack user
exec sudo -u stack -i