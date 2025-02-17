#!/bin/bash

set -eu

source "suv-ansi-colors.sh"
source "suv-options.sh"

echo 
echo -e ${ANSI_BG_BLUE}"Removing image for container"${ANSI_OFF} ${ANSI_BG_PURPLE}${CONTAINER_NAME}${ANSI_OFF} ${ANSI_BG_BLUE}"..."${ANSI_OFF}
docker image rm "${CONTAINER_IMAGE_NAME}"

echo
