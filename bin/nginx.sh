#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

echo "Configure nginx web server production"

# sudo ln -s /etc/nginx/sites-available/flaskr /etc/nginx/sites-enabled || echo "symbolic link already created"
docker compose up --detach --pull always nginx
