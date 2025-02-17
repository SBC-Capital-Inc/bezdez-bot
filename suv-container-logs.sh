#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

echo 
echo -e ${ANSI_BG_BLUE}"Logs of"${ANSI_OFF} ${ANSI_BG_PURPLE}${CONTAINER_NAME}${ANSI_OFF} ${ANSI_BG_BLUE}"..."${ANSI_OFF}
docker logs -f "${CONTAINER_NAME}"

echo 