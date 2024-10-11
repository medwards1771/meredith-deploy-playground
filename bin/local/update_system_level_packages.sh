#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euo pipefail

SERVER=$1

if [ $SERVER = webserver ]; then
    PUBLIC_IP=ec2-18-223-186-177.us-east-2.compute.amazonaws.com
elif [ $SERVER = buildkite ]; then
    PUBLIC_IP=ec2-18-226-165-142.us-east-2.compute.amazonaws.com
else
    echo "No server given or unknown server"
    exit
fi

ssh ubuntu@${PUBLIC_IP} << 'EOF'
set -euo pipefail

echo "========= Update apt package index to get latest package versions ========="
sudo apt-get -y update

echo "========= Upgrade all out-of-date apt packages ========="
sudo apt-get -y upgrade

echo "========= Remove unneeded packages ========="
sudo apt-get -y autoremove
EOF