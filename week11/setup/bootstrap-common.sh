#!/usr/bin/env bash
set -euo pipefail

NODE_IP="${1:-}"
MASTER_IP="${2:-192.168.50.10}"
K8S_VERSION="${K8S_VERSION:-v1.30}"

if [ -z "$NODE_IP" ]; then
  echo "Usage: bootstrap-common.sh <node_ip> <master_ip>"
  exit 1
fi

echo "[common] node_ip=${NODE_IP}, master_ip=${MASTER_IP}, k8s=${K8S_VERSION}"
export DEBIAN_FRONTEND=noninteractive

echo "[common] disable swap"
sudo swapoff -a || true
sudo sed -i.bak '/ swap / s/^/#/' /etc/fstab || true

echo "[common] kernel modules"
cat <<'EOF' | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay || true
sudo modprobe br_netfilter || true

echo "[common] sysctl"
cat <<'EOF' | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

echo "[common] install base packages"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common

echo "[common] install containerd"
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

echo "[common] crictl config"
cat <<'EOF' | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF

echo "[common] install kubeadm/kubelet/kubectl"
sudo mkdir -p /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
  curl -fsSL "https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/Release.key" \
    | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
fi

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/ /" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "[common] kubelet node ip"
echo "KUBELET_EXTRA_ARGS=--node-ip=${NODE_IP}" | sudo tee /etc/default/kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet || true
sudo systemctl enable kubelet

echo "[common] completed"
