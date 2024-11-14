#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euo pipefail

echo "========= Install buildkite agent ========="
# From https://buildkite.com/docs/agent/v3/ubuntu#installation

echo "Download the Buildkite PGP key to a directory that is only writable by root"
curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/32A37959C2FA5C3C99EFBC32A79206696452D198 | \
    sudo gpg --dearmor -o /usr/share/keyrings/buildkite-agent-archive-keyring.gpg

echo "Add the signed source to list of apt sources"
echo "deb [signed-by=/usr/share/keyrings/buildkite-agent-archive-keyring.gpg] \
    https://apt.buildkite.com/buildkite-agent stable main" | \
    sudo tee /etc/apt/sources.list.d/buildkite-agent.list

echo "Install buildkite agent"
sudo apt-get update && sudo apt-get install -y buildkite-agent
# I ssh'd onto the EC2 instance and updated the INSERT-YOUR-AGENT-TOKEN-HERE value in `/etc/buildkite-agent/buildkite-agent.cfg` file manually

sudo systemctl enable buildkite-agent && sudo systemctl start buildkite-agent

echo "========= Update apt package index to get latest package versions ========="
sudo apt-get update
