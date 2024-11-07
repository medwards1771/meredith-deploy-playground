#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euo pipefail

MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=ec2-3-145-146-61.us-east-2.compute.amazonaws.com

scp bin/local/install_buildkite_agent.sh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP}:/tmp/install_buildkite_agent.sh
scp bin/local/install_docker.sh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP}:/tmp/install_docker.sh

ssh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP} << 'EOF'
set -euo pipefail

echo "========= Create new access group for docker =========" # Needed to buildkite-agent to run docker processes
sudo apt-get install members
sudo newgrp docker

DOCKER="$(which docker)"
if [ $DOCKER = "/usr/bin/docker" ]; then
  echo "Docker already installed"
else
  mv /tmp/install_docker.sh .
  ./install_docker.sh
  rm install_docker.sh
fi

BUILDKITE_AGENT="$(which buildkite-agent)"
if [ $BUILDKITE_AGENT = "/usr/bin/buildkite-agent" ]; then
  echo "buildkite-agent already installed"
else
  mv /tmp/install_buildkite_agent.sh .
  ./install_buildkite_agent.sh
  rm install_buildkite_agent.sh
fi
EOF
