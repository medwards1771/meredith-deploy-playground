#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

# connect to buildkite-agent-runner ec2 instance and run commands in EOF block
ssh ubuntu@ec2-18-117-103-65.us-east-2.compute.amazonaws.com << 'EOF'
set -euo pipefail

sudo apt-get update
sudo apt-get -y upgrade

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

echo "Allow docker to be run as buildkite-agent user"
sudo usermod -aG docker buildkite-agent
sudo newgrp docker
docker run hello-world
EOF

# Manually added my Docker login password as an ENV VAR inside the file /etc/buildkite-agent/hooks/environment