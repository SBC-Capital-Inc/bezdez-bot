# 
# suvorov:
# Импортируем нужные модули
# 
from telegram import Update, InlineKeyboardMarkup, InlineKeyboardButton
from telegram.ext import CallbackContext
import sqlite3
import asyncio

#
# Получает список машин из базы данных
# 
async def get_trucks():

    """Получает список машин из базы данных"""

    conn = sqlite3.connect("trucks.db", isolation_level=None)  # Ensure proper transactions
    cursor = conn.cursor()
    
    cursor.execute("SELECT id, model, number FROM trucks")
    trucks = cursor.fetchall()
    
    print(f"📦 Данные из БД: {trucks}")  # Отладка

    conn.close()
    return trucks

#
# Получает список машин из базы данных
# 
# 
# Показывает список машин
# 
async def show_truck_list(update: Update, context: CallbackContext):

    """Отображает список машин пользователю"""

    print("🛠 Вызов show_truck_list()") 

    if update.callback_query:
        query = update.callback_query
        await query.answer()
        message = query.message
    else:
        message = update.message

    trucks = await get_trucks()

    if not trucks:
        await message.reply_text("🚛 Машины не найдены в базе данных.")
        return

    keyboard = [
        [InlineKeyboardButton(f"{model} {number}", callback_data=f"truck_{truck_id}")]
        for truck_id, model, number in trucks
    ]

    reply_markup = InlineKeyboardMarkup(keyboard)
    await message.reply_text("Выберите машину:", reply_markup=reply_markup)
