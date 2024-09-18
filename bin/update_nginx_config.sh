#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=ec2-18-223-186-177.us-east-2.compute.amazonaws.com

scp flaskr-nginx-server-block ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP}:/tmp/flaskr-nginx-server-block

ssh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP} << 'EOF'
set -euo pipefail

echo "Configure nginx server block for flaskr"
sudo mv /tmp/flaskr-nginx-server-block /etc/nginx/sites-available/flaskr
sudo ln -s /etc/nginx/sites-available/flaskr /etc/nginx/sites-enabled

echo "Check for nginx syntax errors"
sudo nginx -t

echo "Reload and verify nginx configuration"
sudo systemctl restart nginx
EOF