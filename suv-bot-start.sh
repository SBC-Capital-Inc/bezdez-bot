#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

# 
# Запуск бота
# 
echo 
echo -e ${ANSI_BG_BLUE}"Запускаю бота 🚀 ..."${ANSI_OFF}
echo 

set +e

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Run the bot and redirect stderr to both the terminal and the error log
    $VENV_PYTHON3 $bot2_py 2> >(tee "$bot2_error_log" >&2)
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    python3  $bot2_py 2> >(tee "$bot2_error_log" >&2)
else
    echo "Unsupported OS: $OSTYPE"
fi

echo 