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

nctl-compile
echo "nctl-compile complete."