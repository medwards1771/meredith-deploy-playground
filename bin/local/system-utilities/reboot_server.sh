#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`           Display each command as executed, preceded by +
# `o pipefail`	Ensure chained commands (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

instance=$1
SERVER_PUBLIC_IP=$(grep "^${instance}-deploy-playground:" bin/local/webserver.txt | cut -d' ' -f2)

ssh ubuntu@${SERVER_PUBLIC_IP} << 'EOF'
set -euo pipefail

echo "========= Restart system ========="
sudo systemctl reboot
EOF
