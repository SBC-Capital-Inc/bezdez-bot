#!/bin/bash

set -eu

source "../ansi-colors.sh"
source "options.sh"

echo 
echo -e "${ANSI_BG_BLUE}Removing image for container ${ANSI_BG_PURPLE}\"${CONTAINER_TAG}\"${ANSI_BG_BLUE}...${ANSI_OFF}"
docker image rm ${IMAGE_NAME}

echo

