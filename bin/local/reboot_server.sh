#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

SERVER=$1

if [ $SERVER = webserver ]; then
    PUBLIC_IP=ec2-18-223-186-177.us-east-2.compute.amazonaws.com
else
    echo "No server given or unknown server"
    exit
fi

ssh ubuntu@${PUBLIC_IP} << 'EOF'
set -euo pipefail

echo "========= Restart system ========="
sudo sudo systemctl reboot
EOF
