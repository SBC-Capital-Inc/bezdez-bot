#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

# 
# Create the virtual environment if it doesn't exist
# 
if [ ! -d "$VENV_PATH" ]; then
    python3 -m "$VENV_NAME" "$VENV_PATH"
fi

# 
# Activate the virtual environment
# 
echo "Activating virtual environment"
source "$VENV_ACTIVATE"

# 
# Confirm activation
# 
echo 
echo -e "✅" ${ANSI_BG_BLUE}"Virtual environment activated:"${ANSI_OFF} ${ANSI_BG_PURPLE}$VIRTUAL_ENV${ANSI_OFF}

echo 