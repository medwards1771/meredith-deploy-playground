#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euo pipefail

echo "========= Install buildkite agent ========="
# From https://buildkite.com/docs/agent/v3/ubuntu#installation

echo "Download Buildkite PGP key"
curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/32A37959C2FA5C3C99EFBC32A79206696452D198 | \
    sudo gpg --dearmor -o /usr/share/keyrings/buildkite-agent-archive-keyring.gpg

echo "Add the signed source to list of apt sources"
echo "deb [signed-by=/usr/share/keyrings/buildkite-agent-archive-keyring.gpg] \
    https://apt.buildkite.com/buildkite-agent stable main" | \
    sudo tee /etc/apt/sources.list.d/buildkite-agent.list

echo "Install buildkite agent"
sudo apt-get update && sudo apt-get install -y buildkite-agent
sudo systemctl enable buildkite-agent && sudo systemctl start buildkite-agent

echo "******************************************************************************"
echo "Assign agent token in /etc/buildkite-agent/buildkite-agent.cfg"
echo "Set DOCKER_LOGIN_PASSWORD as env var in /etc/buildkite-agent/hooks/environment"
echo "******************************************************************************"
