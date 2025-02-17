#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu 

cached_junk="__pycache__"

git rm -r --cached $cached_junk