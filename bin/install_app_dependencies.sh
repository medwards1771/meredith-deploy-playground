#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

# Set SSH_AUTH_SOCK so that ssh can find the buildkite-agent bind address
export SSH_AUTH_SOCK=/var/lib/buildkite-agent/.ssh/ssh-agent.sock

BUILDKITE_AGENT_RUNNER_PUBLIC_IP=ec2-18-226-165-142.us-east-2.compute.amazonaws.com
MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=ec2-18-223-186-177.us-east-2.compute.amazonaws.com

scp -r requirements.txt ubuntu@${BUILDKITE_AGENT_RUNNER_PUBLIC_IP}.compute.amazonaws.com:tmp/

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
mv ~/tmp/requirements.txt .
pip install -r requirements.txt
EOF

# Had to manually create the dir /run/gunicorn in order to generate PID file :scream:

# I ended up getting this to "work" by following Kenneth Roberts's comment from 10/29/23:
# "I can never get this to work through sock file. I can get it to work like so without sock file:
# proxy_pass <http://127.0.0.1:3000≥;" (I changed this to 0.0.0.0:3000)
# is it insecure to rely on 0.0.0.0 instead of sock?

# To try and resolve "sock file not found blah blah error", I ran the command
# `sudo chmod 755 /home/ubuntu`

# To get gunicorn to run w/o error from web server, I needed to manually activate virtual environment
# ssh'd into web server, then from meredith-deploy-playground ran
#    `. .venv/bin/activate`
#    `.venv/bin/gunicorn --workers 3 --bind unix:flaskr.sock -m 007 flaskr:app

# Had to manually create a /tmp directory to put the systemd file to avoid changing root-level
# permissions at /home/ubuntu or /etc/systemd/system

# Had to manually update nginx config (https://flask.palletsprojects.com/en/2.3.x/deploying/nginx/) at
# /etc/nginx/conf.d/default.conf

# Had to manually add dir meredith-deploy-playground in order to nest flaskr dir within that