#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu 

hostname=$(hostname)
counter=1

echo "Started..."
while true; do
    timestamp=$(date '+%Y%m%d-%H%M%S')
    echo "#### $timestamp - $USER @ $HOSTNAME [$PWD]"
    sleep 10
    ((counter++))
done
echo "Stopped."
