#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

scp default.conf ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com:/tmp/default.conf

# connect to meredith-deploy-playground ec2 instance and run commands in EOF block
ssh ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com << 'EOF'
set -euo pipefail

echo "Move nginx default.conf file to /etc/nginx/conf.d/ dir"
sudo mv /tmp/default.conf /etc/nginx/conf.d/

echo "Reload and verify nginx configuration"
sudo nginx -s reload
sudo nginx -t
sudo systemctl status nginx
EOF