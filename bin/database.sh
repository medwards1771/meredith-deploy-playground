#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

echo "Start database"

# This was redacted in the buildkite UI logs! Interesting. Can you figure out why?
export TREE=$BRANCH
echo "here we go"
echo "$ dolla dolla bill"
echo $TREE

docker compose up --detach database
