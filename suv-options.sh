project_dir="$(pwd)"
bot2_error_log="bot2-error.log"

# 
# https://stackoverflow.com/questions/75608323/how-do-i-solve-error-externally-managed-environment-every-time-i-use-pip-3
# 
VENV_NAME="venv"
VENV_PATH="venv"
VENV_ACTIVATE="$VENV_PATH/bin/activate"
VENV_PIP="$VENV_PATH/bin/pip"
VENV_PYTHON3="$VENV_PATH/bin/python3"

bot2_py="bot2.py"

#
# Это нужно для скриптов git
#
HOSTNAME_LOCAL="macbook-pro"

GIT_REPOSITORY="SBC-Capital-Inc/bezdez-bot.git"
GIT_FEATURE_BRANCH="dev-feature-branch"
GIT_MAIN_BRANCH="main"