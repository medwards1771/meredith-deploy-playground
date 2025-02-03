#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

echo "Deploy changes to production"

if [ -z "${DOCKER_IMAGE:-}" ]; then
  echo ":boom: \$DOCKER_IMAGE missing" 1>&2
  exit 1
fi

manifest="$(mktemp)"

echo '--- :kubernetes: Shipping'
envsubst < bin/kubernetes/deployment.yaml > "${manifest}"
kubectl apply -f "${manifest}"

echo '--- :zzz: Waiting for deployment'
kubectl wait --for condition=available --timeout=300s -f "${manifest}"
