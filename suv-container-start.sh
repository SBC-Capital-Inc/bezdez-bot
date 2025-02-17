#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

# 
# Function to check if a Docker image exists
# 
function image_exists() {
    docker images -q "$CONTAINER_IMAGE_NAME" > /dev/null 2>&1
}

# 
# Check if the Docker image exists; if not, build it
# 
if ! image_exists; then
    echo 
    echo -e ${ANSI_BG_BLUE}"Image" ${ANSI_BG_PURPLE}${CONTAINER_IMAGE_NAME}${ANSI_BG_BLUE} "does not exist. Building image..."${ANSI_OFF}
    ./suv-container-build.sh
#else
    # echo 
    # echo -e "${ANSI_BG_BLUE}Image ${ANSI_BG_PURPLE}\"${IMAGE_NAME}\"${ANSI_BG_BLUE} exists.${ANSI_OFF}"
fi

echo 
echo -e ${ANSI_BG_BLUE}"Creating container" ${ANSI_BG_PURPLE}${CONTAINER_NAME}${ANSI_BG_BLUE}"..."${ANSI_OFF}
docker compose -f ${CONTAINER_YAML} up -d 

echo 
echo -e ${ANSI_BG_BLUE}"Checking container status..."${ANSI_OFF}

# 
# Loop for 5 seconds or until the container is Exited or Running
# 
end=$((SECONDS + 5))
while [ $SECONDS -lt $end ]; do
    container_status=$(docker inspect --format='{{.State.Status}}' "${CONTAINER_NAME}")
    echo -e "${ANSI_BG_BLUE}Current status: ${ANSI_BG_PURPLE}${container_status}${ANSI_OFF}"

    if [[ "$container_status" == "exited" || "$container_status" == "running" ]]; then
        break
    fi
    
    sleep 1
done

if [[ "$container_status" != "running" ]]; then
    echo -e "${ANSI_BG_RED}Container \"${CONTAINER_NAME}\" is not running.${ANSI_OFF}"
else
    echo -e "${ANSI_BG_BLUE}Container ${ANSI_BG_PURPLE}\"${CONTAINER_NAME}\"${ANSI_BG_BLUE} is running successfully.${ANSI_OFF}"
fi

echo 
docker ps --filter "name=${CONTAINER_NAME}"

echo 