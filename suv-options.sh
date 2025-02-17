export PROJECT_NAME="bezdez-bot"
export PROJECT_USER="bezdez"
export PROJECT_USER_SSH_PUBLIC_KEY="bez_ed25519.pub"

# 
# https://stackoverflow.com/questions/75608323/how-do-i-solve-error-externally-managed-environment-every-time-i-use-pip-3
# 
VENV_NAME="venv"
VENV_PATH="venv"
VENV_ACTIVATE="$VENV_PATH/bin/activate"
VENV_PIP="$VENV_PATH/bin/pip"
VENV_PYTHON3="$VENV_PATH/bin/python3"

BOT2_PY="bot2.py"
BOT2_ERROR_LOG="bot2-error.log"

#
# Это нужно для скриптов git
#
HOSTNAME_LOCAL="macbook-pro"

GIT_REPOSITORY="SBC-Capital-Inc/bezdez-bot.git"
GIT_FEATURE_BRANCH="dev-feature-branch"
GIT_MAIN_BRANCH="main"

# 
# Container related
# 
CONTAINER_NAME="bezdez-bot"
CONTAINER_IMAGE_NAME=$CONTAINER_NAME":latest"
CONTAINER_YAML=$CONTAINER_NAME".yml"