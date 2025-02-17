# 
# bezdez:
# Импортируем нужные модули
# 
from telegram import Update, InlineKeyboardMarkup, InlineKeyboardButton
from telegram.ext import CallbackContext
from database import get_db_connection
from config import logger

# 
# bezdez:
# Эта функция вызывается при нажатии на кнопку, которая ведёт в админ-меню.
#
def admin_menu(update: Update, context: CallbackContext):

    #
    # Это строка документации
    #
    """ Выводит меню администратора. """

    query = update.callback_query
    query.answer()

    #
    # Создаём клавиатуру с кнопками
    # 
    keyboard = [
        [InlineKeyboardButton("Редактировать автомобили", callback_data="admin_update_vehicle")],
        [InlineKeyboardButton("Назначить админа", callback_data="admin_assign")],
        [InlineKeyboardButton("🔙 Главное меню", callback_data="back_to_menu")]
    ]

    #
    # Обновляем текст сообщения и прикрепляем кнопки
    # 
    query.edit_message_text(text="Админ-панель:", reply_markup=InlineKeyboardMarkup(keyboard))