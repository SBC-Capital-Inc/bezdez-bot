#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -e

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

# 
# Check if a comment is provided as an argument
# 
if [ -n "$1" ]; then
    commit_message="$1"
else
    # # 
    # # Prompt the user for a commit message
    # # 
    # echo 
    # echo -e ${ANSI_BG_BLUE}"Enter commit message (press ENTER for '-'):"${ANSI_OFF}
    # read commit_message

    # # 
    # # If the user just presses ENTER, set commit message to "-"
    # # 
    # commit_message=${commit_message:-"-"}

    echo
    echo -e ${ANSI_BG_BLUE}"Commit message is set to"${ANSI_OFF} ${ANSI_BG_PURPLE}"-"${ANSI_OFF}
    commit_message="-"
fi

set -u

# 
# Execute Git commands
# 
echo
git add . && \
    git commit -m "$commit_message" && \
    git push origin main

echo 
echo -e ${ANSI_BG_BLUE}"Git upload completed succesfully"${ANSI_OFF}
echo 

# 
# Create PR
# 
# gh pr create \
#     --base main \
#     --head your-branch-name \
#     --title "Your PR Title" \
#     --body "PR Description"