#!/bin/bash

source "suv-ansi-colors.sh"
source "suv-options.sh"

set -eu

echo 
echo -e ${ANSI_BG_BLUE}"Updating"${ANSI_OFF} ${ANSI_BG_PURPLE}"pip"${ANSI_OFF} ${ANSI_BG_BLUE}"..."${ANSI_OFF}
$VENV_PYTHON3 -m pip install --upgrade pip


# sudo apt install -y python3-pip


# echo 
# echo -e ${ANSI_BG_BLUE}"Installing package"${ANSI_OFF} ${ANSI_BG_PURPLE}"nest_asyncio"${ANSI_OFF} ${ANSI_BG_BLUE}"..."${ANSI_OFF}
# $venv_pip install nest_asyncio

echo 
echo -e ${ANSI_BG_BLUE}"Installing package"${ANSI_OFF} ${ANSI_BG_PURPLE}"python-telegram-bot"${ANSI_OFF} ${ANSI_BG_BLUE}"..."${ANSI_OFF}
$VENV_PIP install python-telegram-bot --upgrade

echo
echo -e "✅" ${ANSI_BG_BLUE}"Modules have been successfully installed."${ANSI_OFF}

echo 