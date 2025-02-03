#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`           Display each command as executed, preceded by +
# `o pipefail`	Ensure chained commands (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

mv /tmp/flaskr-node-port-service.yaml .

kubectl apply -f flaskr-node-port-service.yaml

rm flaskr-node-port-service.yaml
