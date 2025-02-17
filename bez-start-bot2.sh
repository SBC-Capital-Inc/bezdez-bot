#!/bin/bash

# -*- coding: utf-8 -*-

# 
# 📌 Настройки
# 
PROJECT_DIR=~/Desktop/Bot 2
VENV_DIR=$PROJECT_DIR/new_venv
LOG_FILE=$PROJECT_DIR/error.log

echo "🚀 Запуск бота..."
echo "🔍 Лог-файл: $LOG_FILE"
echo "----------------------" >> "$LOG_FILE"
echo "$(date) - Запуск бота" >> "$LOG_FILE"

# 
# 1. Перейти в папку проекта
# 
cd "$PROJECT_DIR" || { echo "❌ Ошибка: Папка проекта не найдена!" | tee -a "$LOG_FILE"; exit 1; }

# 
# 2. Создать виртуальное окружение, если его нет
# 
if [ ! -d "$VENV_DIR" ]; then
    echo "🛠️  Создаю виртуальное окружение..."
    python3 -m venv "$VENV_DIR"
fi

# 
# 3. Активировать виртуальное окружение
# 
source "$VENV_DIR/bin/activate"

# 
# 4. Обновить pip
# 
pip install --upgrade pip > /dev/null 2>> "$LOG_FILE"

# 
# 5. Проверить и установить зависимости
# 
REQUIREMENTS_FILE="requirements.txt"
MISSING_MODULES=()

if [ -f "$REQUIREMENTS_FILE" ]; then

    echo "🔍 Проверяю зависимости..."

    while read -r package; do
        if ! python3 -c "import $(echo $package | cut -d'=' -f1)" 2>/dev/null; then
            MISSING_MODULES+=("$package")
        fi
    done < "$REQUIREMENTS_FILE"

    if [ ${#MISSING_MODULES[@]} -ne 0 ]; then
        echo "⚠️  Отсутствующие модули найдены: ${MISSING_MODULES[*]}"
        echo "🛠️  Устанавливаю их..."
        pip install "${MISSING_MODULES[@]}" >> "$LOG_FILE" 2>&1
    else
        echo "✅ Все модули установлены."
    fi

else
    echo "❌ Файл requirements.txt не найден!" | tee -a "$LOG_FILE"
fi

# 
# 6. Запуск бота
# 
echo "🚀 Запускаю бота..."
python3 bot.py 2>> "$LOG_FILE"