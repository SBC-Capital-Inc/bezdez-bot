#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -e  # Exit on error
set -u  # Treat unset variables as an error

# 
# Check hostname
# 
HOSTNAME_CURRENT=$(hostname)
if [[ "$HOSTNAME_CURRENT" != "$HOSTNAME_LOCAL" ]]; then
    echo
    echo -e ${ANSI_BG_RED}"Error:"${ANSI_OFF} "This script must be run on "${ANSI_BG_PURPLE}$HOSTNAME_LOCAL${ANSI_OFF}
    echo -e ${ANSI_BG_BLUE}"Current hostname:"${ANSI_OFF} ${ANSI_BG_PURPLE}$HOSTNAME_CURRENT${ANSI_OFF}
    echo 
    exit 1
fi

echo 
echo -e ${ANSI_BG_BLUE}"Checking out to $GIT_FEATURE_BRACH branch locally..."${ANSI_OFF}
git checkout $GIT_FEATURE_BRACH

echo 
echo -e ${ANSI_BG_BLUE}"Pulling $GIT_FEATURE_BRACH branch from remote..."${ANSI_OFF}
git pull origin $GIT_FEATURE_BRACH

