#!/usr/bin/env bash
set -euo pipefail

MASTER_IP="${1:-192.168.50.10}"
JOIN_FILE="/vagrant/setup/join-command.sh"

echo "[master] master_ip=${MASTER_IP}"

if [ -f /etc/kubernetes/admin.conf ]; then
  echo "[master] already initialized. Skip kubeadm init."
else
  sudo kubeadm init \
    --apiserver-advertise-address="${MASTER_IP}" \
    --apiserver-cert-extra-sans="${MASTER_IP}" \
    --node-name=master \
    --pod-network-cidr=192.168.0.0/16 \
    --cri-socket=unix:///run/containerd/containerd.sock
fi

echo "[master] kubeconfig for vagrant"
mkdir -p /home/vagrant/.kube
sudo cp -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

echo "[master] install Calico"
sudo -u vagrant kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/tigera-operator.yaml || true
sudo -u vagrant kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/custom-resources.yaml || true

echo "[master] generate join command"
JOIN_COMMAND="$(sudo kubeadm token create --print-join-command) --cri-socket=unix:///run/containerd/containerd.sock"
echo "${JOIN_COMMAND}" | sudo tee "${JOIN_FILE}" >/dev/null
sudo chmod +x "${JOIN_FILE}"

echo "[master] join command saved:"
cat "${JOIN_FILE}"
echo "[master] completed"
