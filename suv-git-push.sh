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

# 
# Parse arguments
# 
CREATE_PR=false
commit_message="$(whoami) @ $(hostname)"

for arg in "$@"; do
    case $arg in
        --pr)
            CREATE_PR=true
            shift
            ;;
        *)
            commit_message="$arg"
            shift
            ;;
    esac
done

# 
# Ensure feature branch exists
# 
echo 
echo -e ${ANSI_BG_BLUE}"Ensures that Git client is aware of the latest remote changes"${ANSI_OFF}
git fetch origin

if git show-ref --verify --quiet "refs/heads/$GIT_FEATURE_BRANCH"; then
    echo
    echo -e ${ANSI_BG_BLUE}"Branch"${ANSI_OFF} ${ANSI_BG_PURPLE}$GIT_FEATURE_BRANCH${ANSI_OFF} ${ANSI_BG_BLUE}"exists. Switching"${ANSI_OFF}
    git checkout $GIT_FEATURE_BRANCH
else
    echo
    echo -e ${ANSI_BG_BLUE}"Branch"${ANSI_OFF} ${ANSI_BG_PURPLE}$GIT_FEATURE_BRANCH${ANSI_OFF} ${ANSI_BG_BLUE}"does not exists. Creating."${ANSI_OFF}
    git checkout -b $GIT_FEATURE_BRANCH
fi

# 
# Push the branch (first time only)
# 
echo 
echo -e ${ANSI_BG_BLUE}"Push the" ${ANSI_BG_PURPLE}$GIT_FEATURE_BRANCH${ANSI_OFF} ${ANSI_BG_BLUE}"(first time only)"${ANSI_OFF}
git push --set-upstream origin $GIT_FEATURE_BRANCH || true

# 
# Execute Git commands
# 

echo 
echo -e ${ANSI_BG_BLUE}"Executing:"${ANSI_OFF} ${ANSI_BG_PURPLE}"git add ."${ANSI_OFF}
echo 
git add . 

echo 
echo -e ${ANSI_BG_BLUE}"Executing:"${ANSI_OFF} ${ANSI_BG_PURPLE}"git commit "${ANSI_OFF}
git commit -m "$commit_message"

echo 
echo -e ${ANSI_BG_BLUE}"Executing:"${ANSI_OFF} ${ANSI_BG_PURPLE}"git push origin"${ANSI_OFF}
git push origin $GIT_FEATURE_BRANCH

echo 
echo -e ${ANSI_BG_BLUE}"Git push completed"${ANSI_OFF} ${ANSI_BG_GREEN}"successfully"${ANSI_OFF}

# 
# Create PR if --pr was specified
# 
if [ "$CREATE_PR" = true ]; then
    echo
    echo -e ${ANSI_BG_BLUE}"Creating PR..."${ANSI_OFF}
    gh pr create \
        --base "$GIT_MAIN_BRANCH" \
        --head "$GIT_FEATURE_BRANCH" \
        --title "Merge $GIT_FEATURE_BRANCH to $GIT_MAIN_BRANCH" \
        --body "Merge updates from $GIT_FEATURE_BRANCH @ $HOSTNAME_LOCAL to $GIT_MAIN_BRANCH @ github.com"

    echo 
    echo -e ${ANSI_BG_BLUE}"PR has been created"${ANSI_OFF} ${ANSI_BG_GREEN}"successfully"${ANSI_OFF}
fi

echo