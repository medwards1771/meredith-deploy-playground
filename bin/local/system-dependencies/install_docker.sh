#!/bin/bash

# `e`           Exit script immediately if any command returns a non-zero exit status
# `u`           Exit script immediately if an undefined variable is used
# `o pipefail`  Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euo pipefail

echo "========= Installing Docker ========="
# From https://docs.docker.com/engine/install/ubuntu/

echo "=== Add Docker's official GPG key ==="
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "=== Add Docker repository to apt sources ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Update apt package index so it has access to Docker packages ==="
sudo apt-get update

echo "=== Install Docker tools ==="
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
