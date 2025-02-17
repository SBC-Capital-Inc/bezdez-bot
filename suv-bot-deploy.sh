#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

PROJECT_NAME_DELETE=$(pwd)

cd ..
rm -rf $PROJECT_NAME_DELETE
git clone "https://github.com/"$GIT_REPOSITORY".git"
cd $PROJECT_NAME

./suv-container.bang

