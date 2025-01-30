#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

instance=$1
SERVER_PUBLIC_IP=$(grep "^${instance}-deploy-playground:" bin/local/webserver.txt | cut -d' ' -f2)

ssh ubuntu@${SERVER_PUBLIC_IP} << 'EOF'
set -euxo pipefail

echo "========= Install calico operator and custom resource definitions ========="
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml

echo "========= Install Calico by creating the necessary custom resource ========="
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml

echo "========= Confirm pods are running ========="
kubectl get pods -n calico-system

echo "========= Remove taints on the control plane so you can schedule pods on it ========="
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

echo "========= Confirm that you now have a node in your cluster ========="
kubectl get nodes -o wide
EOF
