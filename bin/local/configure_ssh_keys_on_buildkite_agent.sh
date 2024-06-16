#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

# connect to buildkite-agent-runner ec2 instance and run commands in EOF block
ssh ubuntu@ec2-18-117-103-65.us-east-2.compute.amazonaws.com << 'EOF'
set -euo pipefail

echo "========= Configure SSH Keys ========="
sudo su buildkite-agent
ssh-agent -a ~/.ssh/ssh-agent.sock
export SSH_AUTH_SOCK=/var/lib/buildkite-agent/.ssh/ssh-agent.sock
ssh-add ~/.ssh/id_rsa.meredith-deploy-playground

echo "========= Show SSH Keys ========="
ssh-add -L
EOF