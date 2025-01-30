#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

instance=$1
SERVER_PUBLIC_IP=$(grep "^${instance}-deploy-playground:" bin/local/webserver.txt | cut -d' ' -f2)

scp bin/local/containerd-config.toml ubuntu@${SERVER_PUBLIC_IP}:/tmp/containerd-config.toml

ssh ubuntu@${SERVER_PUBLIC_IP} << 'EOF'
set -euxo pipefail

echo "========= Configure cgroup driver ========="
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/#configuring-the-kubelet-cgroup-driver

sudo mv /tmp/containerd-config.toml /etc/containerd/config.toml
sudo systemctl restart containerd
EOF
