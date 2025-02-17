# 
# Импортируем нужные модули
# 
import os
import logging

# 
# Токен Telegram-бота
# 
TOKEN = os.environ.get("TELEGRAM_BOT_TOKEN")

# 
# Настройка логирования
# 
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

# 
# Файл с администраторами
# 
ADMINS_FILE = "admins.txt"
