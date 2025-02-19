#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`           Display each command as executed, preceded by +
# `o pipefail`	Ensure chained commands (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/#configuring-the-kubelet-cgroup-driver

echo "========= Generate default configuration for containerd and write to config file ========="
containerd config default | sudo tee /etc/containerd/config.toml

echo "========= Set systemd as cgroup ========="
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

echo "========= Make containerd sandbox image version consistent with kubeadm ========="
sudo sed -i 's/ sandbox_image = "registry.k8s.io\/pause:3.8"/ sandbox_image = "registry.k8s.io\/pause:3.10"/' /etc/containerd/config.toml

echo "========= Restart service for change to take effect ========="
sudo systemctl restart containerd
