#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

# 
# Create the virtual environment if it doesn't exist
# 
if [ ! -d "$venv_path" ]; then
    python3 -m "$venv_name" "$venv_path"
fi

# 
# Activate the virtual environment
# 
echo "Activating virtual environment"
source "$venv_activate"

# 
# Confirm activation
# 
echo 
echo -e "✅" ${ANSI_BG_BLUE}"Virtual environment activated:"${ANSI_OFF} ${ANSI_BG_PURPLE}$VIRTUAL_ENV${ANSI_OFF}

echo 