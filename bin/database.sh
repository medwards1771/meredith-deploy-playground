#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

echo "Start database"

if [ -z "$POSTGRES_PASSWORD" ]; then
  echo "POSTGRES_PASSWORD is null or empty"
else
  echo "POSTGRES_PASSWORD has a value"
fi

export POSTGRES_PASSWORD=$POSTGRES_PASSWORD
docker compose up --detach database