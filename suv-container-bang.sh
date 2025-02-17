#!/bin/bash

set -u

./stop.sh
./clear.sh
./build.sh
./start.sh
