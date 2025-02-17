import datetime
import calendar
from telegram import Update, InlineKeyboardMarkup, InlineKeyboardButton

import bot2_logging
import bot2_database

# 
# Главное меню
# 
def get_main_menu():
    return InlineKeyboardMarkup([
        [InlineKeyboardButton("🚛 Посмотреть автопарк", callback_data="view_trucks")],
        [InlineKeyboardButton("📞 Связаться с логистом", callback_data="contact_logistics")],
        [InlineKeyboardButton("📋 Подать заявку", callback_data="submit_application")],
        [InlineKeyboardButton("📄 Посмотреть заявки", callback_data="view_applications")],
        [InlineKeyboardButton("🔧 Админ", callback_data="admin_menu")]
    ])

# 
# 
# Функции для клиентов
# 
# 
def get_clients_keyboard():

    """
    Возвращает InlineKeyboardMarkup со списком клиентов (из таблицы clients).
    """
    try:
        bot2_database.cursor.execute("SELECT id, name FROM clients ORDER BY name")
        rows = bot2_database.cursor.fetchall()
        
        if not rows:
            return InlineKeyboardMarkup([[InlineKeyboardButton("Нет клиентов", callback_data="no_clients")]])
        
        buttons = []

        for client_id, name in rows:
            buttons.append([InlineKeyboardButton(name, callback_data=f"client_{client_id}")])
        buttons.append([InlineKeyboardButton("🔙 Отмена", callback_data="back_to_menu")])
    
        return InlineKeyboardMarkup(buttons)
    
    except Exception as e:
        bot2_logging.logger.error("Ошибка в get_clients_keyboard: %s", e)
        return InlineKeyboardMarkup([[InlineKeyboardButton("Ошибка", callback_data="no_clients")]])

#
# 
# Показывает список всех заявок из таблицы applications.
# 
#
async def show_applications(query):

    """
    Показывает список всех заявок из таблицы applications.
    """

    try:

        bot2_database.cursor.execute("""
            SELECT id, company, manager, delivery_date, fueling_date, fueling_place, price, submission_datetime, status
            FROM applications ORDER BY submission_datetime DESC
        """)        

        applications = bot2_database.cursor.fetchall()
        
        if not applications:
            text = "✅ В базе нет заявок."
            reply_markup = InlineKeyboardMarkup([[InlineKeyboardButton("🔙 Назад", callback_data="back_to_menu")]])
            await query.edit_message_text(text=text, reply_markup=reply_markup, parse_mode='HTML')
            return
        
        text_lines = []

        for app in applications:
            text_lines.append(
                f"<b>🆔 ID:</b> {app[0]}\n"
                f"<b>🏢 Клиент:</b> {app[1]}\n"
                f"<b>👔 Менеджер:</b> {app[2]}\n"
                f"<b>📅 Дата поставки:</b> {app[3]}\n"
                f"<b>⛽ Дата налива:</b> {app[4]}\n"
                f"<b>📍 Место погрузки:</b> {app[5]}\n"
                f"<b>💲 Цена:</b> {app[6]}\n"
                f"<b>🕒 Подано:</b> {app[7]}\n"
                f"<b>📌 Статус:</b> {app[8]}\n"
                "-------"
            )
        text = "<b>Список заявок:</b>\n\n" + "\n".join(text_lines)
        reply_markup = InlineKeyboardMarkup([[InlineKeyboardButton("🔙 Назад", callback_data="back_to_menu")]])
        query.edit_message_text(text=text, reply_markup=reply_markup, parse_mode=ParseMode.HTML)

    except Exception as e:
        bot2_logging.logger.error("❌ Ошибка в show_applications: %s", e)
        await query.edit_message_text(text="❌ Ошибка при получении заявок.")
# 
# 
# Inline-календарь (для выбора дат)
# 
# 
def build_calendar(year, month):
    keyboard = []
    week_days = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    keyboard.append([InlineKeyboardButton(day, callback_data="IGNORE") for day in week_days])
    today = datetime.date.today()
    tomorrow = today + datetime.timedelta(days=1)
    quick_row = [
        InlineKeyboardButton("Сегодня", callback_data=f"CAL:{today.year}:{today.month}:{today.day}"),
        InlineKeyboardButton("Завтра", callback_data=f"CAL:{tomorrow.year}:{tomorrow.month}:{tomorrow.day}")
    ]
    keyboard.append(quick_row)
    month_calendar = calendar.monthcalendar(year, month)
    for week in month_calendar:
        row = []
        for day in week:
            if day == 0:
                row.append(InlineKeyboardButton(" ", callback_data="IGNORE"))
            else:
                row.append(InlineKeyboardButton(str(day), callback_data=f"CAL:{year}:{month}:{day}"))
        keyboard.append(row)
    prev_month = month - 1
    prev_year = year
    if prev_month < 1:
        prev_month = 12
        prev_year = year - 1
    next_month = month + 1
    next_year = year
    if next_month > 12:
        next_month = 1
        next_year = year + 1
    navigation_row = [
        InlineKeyboardButton("<", callback_data=f"CALNAV:{prev_year}:{prev_month}"),
        InlineKeyboardButton(f"{calendar.month_name[month]} {year}", callback_data="IGNORE"),
        InlineKeyboardButton(">", callback_data=f"CALNAV:{next_year}:{next_month}")
    ]
    keyboard.append(navigation_row)
    return InlineKeyboardMarkup(keyboard)