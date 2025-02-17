#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -e  # Exit on error
set -u  # Treat unset variables as an error

echo 
echo -e ${ANSI_BG_BLUE}"Checking out to $GIT_MAIN_BRANCH branch locally..."${ANSI_OFF}
git checkout $GIT_MAIN_BRANCH

echo 
echo -e ${ANSI_BG_BLUE}"Pulling $GIT_MAIN_BRANCH branch from remote..."${ANSI_OFF}
git pull origin $GIT_MAIN_BRANCH

