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

# Run the bot and redirect stderr to both the terminal and the error log
$venv_python3 $bot2_py 2> >(tee "$bot2_error_log" >&2)

echo 