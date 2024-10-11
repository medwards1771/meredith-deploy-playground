#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=ec2-18-223-186-177.us-east-2.compute.amazonaws.com

ssh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP} << 'EOF'
set -euo pipefail

echo "========= Update apt package index to get latest package versions ========="
sudo apt-get update

echo "========= Add OpenSSH to the list of services whitelisted by UFW firewall ========="
sudo ufw allow OpenSSH
echo "========= Enable UFW firewall ========="
printf "y" | sudo ufw enable

echo "========= Install nginx ========="
sudo apt-get install -y nginx

echo "========= Whitelist nginx HTTP + HTTPS connections in UFW firewall ========="
sudo ufw allow 'Nginx Full'

sudo ufw status
systemctl status nginx

echo "========= Install Docker ========="
echo "Add Docker's official GPG key"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Add the GPG keyring repository to apt sources"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "Install the latest version of Docker"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Allow Docker to be run as ubuntu user"
sudo usermod -aG docker ubuntu
sudo newgrp docker
docker run hello-world
EOF
