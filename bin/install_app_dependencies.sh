#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=ec2-18-223-186-177.us-east-2.compute.amazonaws.com

# In order for the `scp -r` to work, I had to:
# - upload a copy of "meredith-deploy-playground-web-server.pem" to the buildkite-agent-runner and move to dir
#   /var/lib/buildkite-agent/.ssh/
# - `sudo chown buildkite-agent:buildkite-agent /var/lib/buildkite-agent/.ssh/meredith-deploy-playground-web-server.pem`
# - create "/var/lib/buildkite-agent/.ssh/config" file and add
#   Host ec2-18-223-186-177.us-east-2.compute.amazonaws.com
#   AddKeysToAgent yes
#   IdentityFile /var/lib/buildkite-agent/.ssh/meredith-deploy-playground-web-server.pem
#   User ubuntu
# - ssh onto the buildkite-agent-runner, and from there ssh onto the meredith-deploy-playground web server

scp -r requirements.txt ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP}:/tmp/

ssh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP} << 'EOF'
set -euxo pipefail

echo "Install flask and its dependencies on web server"
sudo apt-get update
sudo apt-get -y install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools python3-venv

echo "Recreate project directory"
rm -rf meredith-deploy-playground
mkdir meredith-deploy-playground

echo "Activate python virtual environment"
cd meredith-deploy-playground
python3 -m venv .venv
source .venv/bin/activate

echo "Install flask app requirements with pip"
mv /tmp/requirements.txt .
pip install -r requirements.txt
EOF