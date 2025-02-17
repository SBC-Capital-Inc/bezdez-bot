#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu 

user=$(whoami)
hostname=$(hostname)
counter=1

echo "Started..."
while true; do
    timestamp=$(date '+%Y%m%d-%H%M%S')
    echo "$counter $timestamp - $user @ $hostname [$PWD]"
    sleep 5
    ((counter++))
done
echo "Stopped."
