# Run from local machine to update flaskr.service on meredith-deploy-playground-web-server

#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=ec2-18-223-186-177.us-east-2.compute.amazonaws.com

scp bin/flaskr.service ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP}:/tmp/flaskr.service

ssh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP} << 'EOF'
set -euo pipefail

echo "Move systemd unit file to Ubuntu init system"
sudo mv /tmp/flaskr.service /etc/systemd/system/flaskr.service

echo "stop flaskr, reload daemons, enable flaskr, and start flaskr since flaskr.service file changed on disk"
sudo systemctl stop flaskr
sudo systemctl daemon-reload
sleep 10
sudo systemctl enable flaskr
sudo systemctl start flaskr

echo "Check flaskr service status"
sudo systemctl status flaskr
EOF