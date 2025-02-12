#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`           Display each command as executed, preceded by +
# `o pipefail`	Ensure chained commands (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

echo "========= Install calico operator and custom resource definitions ========="
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml

echo "========= Pause for 5 seconds to let kubectl clock new CRDs ========="
sleep 5

echo "========= Install Calico by creating the necessary custom resource ========="
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml

echo "========= Remove taints on the control plane so you can schedule pods on it ========="
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

echo "========= Confirm that you now have a node in your cluster ========="
kubectl get nodes -o wide
