project_dir="$(pwd)"
bot2_error_log="bot2-error.log"

# 
# https://stackoverflow.com/questions/75608323/how-do-i-solve-error-externally-managed-environment-every-time-i-use-pip-3
# 
venv_name="venv"
venv_path="venv"
venv_activate="$venv_path/bin/activate"
venv_pip="$venv_path/bin/pip"
venv_python3="$venv_path/bin/python3"

bot2_py="bot2.py"