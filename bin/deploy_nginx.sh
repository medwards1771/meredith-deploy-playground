#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euo pipefail

echo "Configure nginx web server production"

docker compose up --detach --pull always nginx

echo "Wait 15s before performing health check"
sleep 15

HEALTH_STATUS=$(docker inspect --format '{{.State.Health.Status}}' "meredith-deploy-playground-nginx-1")

if [[ $HEALTH_STATUS == "healthy" ]]; then
  echo "Container is healthy. Deployment successful."
  exit 0
elif [[ $HEALTH_STATUS == "unhealthy" ]]; then
  echo "Container is unhealthy. Aborting deployment."
  exit 1
elif [[ $HEALTH_STATUS == "starting" ]]; then
  echo "Container starting"
  exit 2
fi
