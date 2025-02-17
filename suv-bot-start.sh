#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

echo 
echo -e ${ANSI_BG_BLUE}"whoami:"${ANSI_OFF}   ${ANSI_BG_PURPLE}$(whoami)${ANSI_OFF}
echo -e ${ANSI_BG_BLUE}"hostname:"${ANSI_OFF} ${ANSI_BG_PURPLE}$(hostname)${ANSI_OFF}
echo -e ${ANSI_BG_BLUE}"pwd:"${ANSI_OFF}      ${ANSI_BG_PURPLE}$(pwd)${ANSI_OFF}

# 
# Запуск бота
# 
echo 
echo -e ${ANSI_BG_BLUE}"Запускаю бота 🚀 ..."${ANSI_OFF}
echo 

set +e

# Run the bot and redirect stderr to both the terminal and the error log
# $VENV_PYTHON3 $BOT2_PY 2> >(tee "$BOT2_ERROR_LOG" >&2)
$VENV_PYTHON3 $BOT2_PY

echo 