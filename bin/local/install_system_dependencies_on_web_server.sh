#!/bin/bash

# `e`	          Exit script immediately if any command returns a non-zero exit status
# `u`	          Exit script immediately if an undefined variable is used
# `x`           Display each command as executed, preceded by +
# `o pipefail`	Ensure chained commands (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

instance=$1
SERVER_PUBLIC_IP=$(grep "^${instance}-deploy-playground:" bin/local/webserver.txt | cut -d' ' -f2)

scp bin/local/install_buildkite_agent.sh ubuntu@${SERVER_PUBLIC_IP}:/tmp/install_buildkite_agent.sh
scp bin/local/install_docker.sh ubuntu@${SERVER_PUBLIC_IP}:/tmp/install_docker.sh

ssh ubuntu@${SERVER_PUBLIC_IP} << 'EOF'
set -euxo pipefail

if ! which docker &> /dev/null; then
  echo "Docker is not installed. Installing..."
  mv /tmp/install_docker.sh .
  ./install_docker.sh
  rm install_docker.sh
else
  echo "Docker is already installed."
fi

if ! which buildkite-agent &> /dev/null; then
  echo "buildkite-agent is not installed. Installing..."
  mv /tmp/install_buildkite_agent.sh .
  ./install_buildkite_agent.sh
  rm install_buildkite_agent.sh
else
  echo "buildkite-agent already installed"
fi

echo "=== Allow buildkite-agent to run docker processes ==="
sudo usermod -aG docker buildkite-agent
EOF
