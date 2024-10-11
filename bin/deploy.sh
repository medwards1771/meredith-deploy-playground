#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP=ec2-18-223-186-177.us-east-2.compute.amazonaws.com

echo "Deploy changes to production"

# something seems a lil weird about using EOF to run scripts on nginx instance. look into alternatives, princess!
ssh ubuntu@${MEREDITH_DEPLOY_PLAYGROUND_WEB_SERVER_PUBLIC_IP} << 'EOF'
set -euxo pipefail

docker compose up --detach --pull always web
EOF
