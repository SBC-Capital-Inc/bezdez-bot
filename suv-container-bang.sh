#!/bin/bash

set -u

./suv-container-stop.sh
./suv-container-clear.sh
./suv-container-build.sh
./suv-container-start.sh
./suv-container-logs.sh
