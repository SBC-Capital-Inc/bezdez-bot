#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -e
set -u

export PROJECT_NAME="bezdez-bot"
export PROJECT_USER="bezdez"
export PROJECT_USER_SSH_PUBLIC_KEY="bez_ed25519.pub"

# 
# Collect additional arguments for the docker build command
# 
BUILD_ARGS=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --no-cache)
            BUILD_ARGS+=" --no-cache"
            ;;
        --*)
            # If there are other options you want to handle, add them here
            BUILD_ARGS+=" $1"
            ;;
        *)
            # If it's not an option, assume it's an argument to pass to docker buildx
            BUILD_ARGS+=" $1"
            ;;
    esac
    shift
done

# 
# Generate timestamp and log filename
# 
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
LOG_FILE="build-"${CONTAINER_NAME}".log"
# LOG_FILE="build-${CONTAINER_NAME}-${TIMESTAMP}.log"

echo 
echo -e ${ANSI_BG_BLUE}"Build log file:"${ANSI_OFF} ${ANSI_BG_PURPLE}$LOG_FILE${ANSI_OFF}

echo 
echo -e ${ANSI_BG_BLUE}"Building container"${ANSI_OFF} ${ANSI_BG_PURPLE}${CONTAINER_NAME}${ANSI_OFF} ${ANSI_BG_BLUE}"..."${ANSI_OFF}

docker \
    buildx \
    build \
    --build-arg PROJECT_NAME=$PROJECT_NAME  \
    --build-arg PROJECT_USER=$PROJECT_USER  \
    --build-arg PROJECT_USER_SSH_PUBLIC_KEY=$PROJECT_USER_SSH_PUBLIC_KEY  \
    -t ${CONTAINER_IMAGE_NAME} \
    $BUILD_ARGS \
    ./ 2>&1 | tee "$LOG_FILE"

echo 
echo -e ${ANSI_BG_BLUE}"Build log saved to:"${ANSI_OFF} ${ANSI_BG_PURPLE}$LOG_FILE${ANSI_OFF}
echo 