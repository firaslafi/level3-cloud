#!/bin/bash

# Redirect all output to a log file and console
exec > >(tee /var/log/k8s-install.log|logger -t user-data -s 2>/dev/console) 2>&1


# Wait for internet connectivity
until ping -c 1 google.com; do
  echo "Waiting for internet connectivity..."
  sleep 5
done

# Prevent needrestart from prompting during package installations
# export DEBIAN_FRONTEND=noninteractive
# echo 'needrestart $nrconf{restart} = "a";' >> /etc/needrestart/needrestart.conf
mkdir -p /etc/needrestart/conf.d
echo '$nrconf{restart} = "a";' | tee /etc/needrestart/conf.d/99-k8s-automation.conf

# Force APT to use IPv4 to avoid potential issues/delay with IPv6 networks
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

# 1. Update and install basic dependencies
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gpg conntrack haveged

# 2. Disable Swap (Kubernetes will not start if swap is on)
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# 3. Enable Kernel Modules for Networking
# These allow Kubernetes to manage bridge traffic correctly
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# 4. Configure Sysctl for Networking
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

# 5. Install Containerd (The Container Runtime)
apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
# Set SystemdCgroup to true (Crucial for stability)
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd

# 6. Install Kubernetes Tools (kubeadm, kubelet, kubectl)
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl # Prevents accidental updates