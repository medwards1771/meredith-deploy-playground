#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=ec2-3-145-146-61.us-east-2.compute.amazonaws.com

ssh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP} << 'EOF'
set -euo pipefail

echo "========= Restart system ========="
sudo sudo systemctl reboot
EOF
