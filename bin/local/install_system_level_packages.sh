#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=ec2-18-223-186-177.us-east-2.compute.amazonaws.com

ssh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP} << 'EOF'
set -euo pipefail

# Update apt package index to get latest package versions
sudo apt-get update

# Add OpenSSH to the list of services whitelisted by UFW firewall
sudo ufw allow OpenSSH
# Enable UFW firewall
printf "y" | sudo ufw enable

# Install nginx
sudo apt-get install -y nginx

# Whitelist nginx HTTP + HTTPS connections in UFW firewall
sudo ufw allow 'Nginx Full'

sudo ufw status
systemctl status nginx

# "Install networking tools"
sudo apt-get install -y net-tools
EOF
