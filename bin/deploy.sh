#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

echo "Deploy changes to production"

echo '--- :kubernetes: Shipping'
kubectl apply -f bin/k8s/deployment.yaml

echo '--- :zzz: Waiting for deployment'
kubectl wait --for condition=available --timeout=60s -f bin/k8s/deployment.yaml
