#!/usr/bin/env bash
set -euo pipefail

echo "[1/6] Install yum-utils"
sudo yum install -y yum-utils

echo "[2/6] Add Docker CE repository"
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "[3/6] Install Docker packages"
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[4/6] Start and enable Docker daemon"
sudo systemctl start docker
sudo systemctl enable docker

echo "[5/6] Add vagrant user to docker group"
sudo usermod -aG docker vagrant

echo "[6/6] Docker version with sudo"
sudo docker version

cat <<'MSG'

Docker installation completed.

The current user was added to the docker group.
Please logout and login again:

  exit
  vagrant ssh

Then verify:

  docker version
  docker run hello-world

MSG
