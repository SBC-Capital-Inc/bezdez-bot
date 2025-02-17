#/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

echo
echo -e ${ANSI_BG_BLUE}"Stopping container"${ANSI_OFF} ${ANSI_BG_PURPLE}${CONTAINER_NAME}${ANSI_OFF} ${ANSI_BG_BLUE}"..."${ANSI_OFF}
docker compose -f ${CONTAINER_YAML} down

echo