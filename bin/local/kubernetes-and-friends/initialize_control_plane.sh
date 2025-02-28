#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`           Display each command as executed, preceded by +
# `o pipefail`	Ensure chained commands (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

echo "========= Initialize control plane ========="

mv /tmp/kubeadm-config.yaml .
sudo kubeadm init --config kubeadm-config.yaml
rm kubeadm-config.yaml

echo "========= Grant ubuntu user admin access to cluster resources ========="
mkdir -p /home/ubuntu/.kube
sudo cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config

echo "========= Grant buildkite-agent user admin access to cluster resources ========="
sudo mkdir -p /var/lib/buildkite-agent/.kube
sudo cp /etc/kubernetes/admin.conf /var/lib/buildkite-agent/.kube/config
sudo chown buildkite-agent:buildkite-agent /var/lib/buildkite-agent/.kube/config
