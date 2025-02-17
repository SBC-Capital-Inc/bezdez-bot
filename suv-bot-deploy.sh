#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

export GIT_REPOSITORY=$GIT_REPOSITORY
PROJECT_NAME_DELETE=$(pwd)

cd ..
rm -rf $PROJECT_NAME_DELETE
echo git clone "https://github.com/"$GIT_REPOSITORY
git clone "https://github.com/"$GIT_REPOSITORY
cd $PROJECT_NAME

./suv-container-bang.sh

