#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euo pipefail

MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=$(grep "^publicdnsname:" bin/local/webserver.txt | cut -d' ' -f2)

ssh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP} << 'EOF'
set -euo pipefail

echo "========= Update the local package list ========="
sudo apt-get -y update

echo "========= Upgrade installed packages ========="
sudo apt-get -y upgrade

echo "========= Upgrade packages and remove obsolete dependencies ========="
sudo apt dist-upgrade -y

echo "========= Remove unneeded packages ========="
sudo apt-get -y autoremove
EOF
