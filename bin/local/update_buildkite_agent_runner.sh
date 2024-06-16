#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

# connect to buildkite-agent-runner ec2 instance and run commands in EOF block
ssh ubuntu@ec2-18-117-103-65.us-east-2.compute.amazonaws.com << 'EOF'
set -euo pipefail

echo "========= Update apt itself and its packages ========="
sudo apt-get update
sudo apt-get -y upgrade
EOF