#!/bin/bash -i
set -m

# Check if an argument is provided
if [ -n "$1" ]; then
    # Use the provided path as the activation script
    source $1/activate
else
    # Use the default path as the activation script
    source /app/casper-nctl/activate
fi

sed -i 's/^allow_request_speculative_exec = false/allow_request_speculative_exec = true/' ./casper-node/resources/local/config.toml
nctl-assets-setup
find $NCTL/assets/ -name 'secret_key.pem' -exec chmod go+r {} \;
nctl-start

tail -f $NCTL/assets/net-1/nodes/node-1/logs/stderr.log