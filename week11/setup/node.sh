#!/usr/bin/env bash
set -euo pipefail

JOIN_FILE="/vagrant/setup/join-command.sh"

if [ -f /etc/kubernetes/kubelet.conf ]; then
  echo "[node] already joined. Skip."
  exit 0
fi

echo "[node] wait for ${JOIN_FILE}"
for i in $(seq 1 120); do
  if [ -s "${JOIN_FILE}" ]; then
    break
  fi
  echo "[node] waiting... ${i}/120"
  sleep 5
done

if [ ! -s "${JOIN_FILE}" ]; then
  echo "[node] join command not found."
  exit 1
fi

echo "[node] join cluster"
sudo bash "${JOIN_FILE}"
echo "[node] completed"
