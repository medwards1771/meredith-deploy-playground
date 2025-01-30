#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

instance=$1
SERVER_PUBLIC_IP=$(grep "^${instance}-deploy-playground:" bin/local/webserver.txt | cut -d' ' -f2)

scp bin/local/kubeadm-config.yaml ubuntu@${SERVER_PUBLIC_IP}:/tmp/kubeadm-config.yaml

ssh ubuntu@${SERVER_PUBLIC_IP} << 'EOF'
set -euxo pipefail

echo "========= Initialize cluster with calico-provided CIDR ========="
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart#create-a-single-host-kubernetes-cluster

mv /tmp/kubeadm-config.yaml .
sudo kubeadm init --config kubeadm-config.yaml
rm kubeadm-config.yaml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
EOF
