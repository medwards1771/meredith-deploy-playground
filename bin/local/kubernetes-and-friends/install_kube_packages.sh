#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`           Display each command as executed, preceded by +
# `o pipefail`	Ensure chained commands (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

echo "========= Update the apt package index ========="
sudo apt-get update

echo "========= Install packages needed to use the Kubernetes apt repository ========="
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

echo "========= Download the public signing key for the Kubernetes package repositories ========="
if [ -e "/etc/apt/keyrings/kubernetes-apt-keyring.gpg" ]; then
    echo "Signing key already downloaded"
else
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
fi

echo "========= Add the Kubernetes repository to apt sources ========="
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list`

echo "=== Update apt package index so it has access to Kubernetes packages ==="
sudo apt-get update

echo "========= Install kubelet, kubeadm, and kubectl then pin versions ========="
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "========= Enable kubelet service before running kubeadm ========="
sudo systemctl enable --now kubelet
