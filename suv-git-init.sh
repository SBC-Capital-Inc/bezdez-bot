#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

# 
# Initialize a new Git repository if it's not already a git repo
# 
if [ ! -d ".git" ]; then
    git init
else
    echo 
    echo -e "Git repository already initialized."
fi

# 
# Add the remote repository URL
# 
git remote add origin git@github.com:$GIT_REPOSITORY

# 
# Check if the README.md or any other file exists in the remote repo
# If the remote repo already has files (like README.md), avoid pulling them into your local repo
# You can fetch the current state of the remote without merging anything
# 
git fetch origin

# 
# If the remote repository is empty, we can safely push our local files
# If it's not empty, the script will assume that you want to resolve any conflicts manually
# 
if git ls-remote --exit-code origin main; then

    echo 
    echo -e "Remote repository already has content. Checking for conflicts..."

    # 
    # Stage all local files for commit (to ensure they are added)
    # 
    git add .

    #
    # Commit local changes (if necessary)
    # 
    git commit -m "Initial commit of the new project"

    #
    # Now, pull the changes from the remote repository and rebase them onto your local changes
    #
    git pull origin main --rebase

    # 
    # Push the changes to the remote repository
    # 
    git push -u origin main
else
    # 
    # If the remote repository is empty, simply push your local files
    # 
    echo
    echo -e "Remote repository is empty, pushing local files..."
    git add .
    git commit -m "Initial commit of the new project"
    git push -u origin main
fi