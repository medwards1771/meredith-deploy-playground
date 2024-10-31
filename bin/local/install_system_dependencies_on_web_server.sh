#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=ec2-18-223-186-177.us-east-2.compute.amazonaws.com

ssh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP} << 'EOF'
set -euxo pipefail

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

echo "========= Install members command ========="
sudo apt-get install members

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

echo "Create new group and add buildkite-agent as member"
sudo newgrp docker
sudo usermod -aG docker buildkite-agent

echo "========= Install buildkite agent ========="
# From https://buildkite.com/docs/agent/v3/ubuntu#installation
echo "Download the Buildkite PGP key to a directory that is only writable by root"
sudo curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/32A37959C2FA5C3C99EFBC32A79206696452D198 | \
    sudo gpg --dearmor -o /usr/share/keyrings/buildkite-agent-archive-keyring.gpg
echo "Add the signed source to list of apt sources"
echo "deb [signed-by=/usr/share/keyrings/buildkite-agent-archive-keyring.gpg] \
    https://apt.buildkite.com/buildkite-agent stable main" | \
    sudo tee /etc/apt/sources.list.d/buildkite-agent.list
echo "Install buildkite agent"
sudo apt-get update && sudo apt-get install -y buildkite-agent
echo "(Configured agent token manually)"
EOF
