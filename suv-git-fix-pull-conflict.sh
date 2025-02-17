#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

git status

# 
# ~/sbc/www/sbc-capital/sbc-capital-investors -> git status
# interactive rebase in progress; onto e1b4cdc
# Last command done (1 command done):
#    pick 1e78135 Initial commit of the new project
# No commands remaining.
# You are currently rebasing branch 'main' on 'e1b4cdc'.
#   (fix conflicts and then run "git rebase --continue")
#   (use "git rebase --skip" to skip this patch)
#   (use "git rebase --abort" to check out the original branch)
# 

git add README.md
git commit -m "Fixed repo initialization conflict due to README.md"
git rebase --continue
git push origin main