# -*- coding: utf-8 -*-

from telegram import Update, InlineKeyboardMarkup, InlineKeyboardButton
from telegram.ext import ContextTypes, CallbackContext

import bot2_logging
import bot2_database
import bot2_ui

#
#
# handler: test_hello
#
#  
async def test_hello_cmd(update: Update, context: ContextTypes.DEFAULT_TYPE):

    await context.bot.send_message(chat_id=update.effective_chat.id, text="I'm a bot, please talk to me!")

#
#
# handler: welcome
#
#  
async def welcome_cmd(update: Update, context: ContextTypes.DEFAULT_TYPE):

    """
    Приветственное сообщение и отображение главного меню.
    """

    await context.bot.send_message(
        chat_id=update.effective_chat.id,
        text="👋 Привет! Добро пожаловать в логистический бот. Выберите действие:",
        reply_markup=bot2_ui.get_main_menu()
    )

#
#
# Обработка запроса "Посмотреть автобарк"
#
#
async def show_trucks_callback(update: Update, context: CallbackContext):

    bot2_logging.logger.info("🚛 Show trucks...")

    # 
	# This retrieves the callback query from the incoming update. 
    # The update object represents an update from Telegram, and callback_query contains the details of the callback event triggered by the user pressing a button on an inline keyboard.
    # 
    query = update.callback_query

    # 
    # This sends an acknowledgment back to Telegram’s servers to inform them that the callback query was received and processed. 
    # It’s a required step to avoid the callback query being stuck in the Telegram server. 
    # By default, this doesn’t send any message back to the user, but it can be used to update the user interface or notify the user.
    # 
    await query.answer()  # Acknowledge the callback
    
    # 
    # This retrieves the data associated with the callback query. 
    # The data field typically contains a string passed when creating the inline keyboard buttons (i.e., what the button sends when clicked). 
    # It’s often used to identify what action the bot should take after the button press.
    # 
    data = query.data

    # 
    # The command await query.edit_message_text(text="show_truck_list()") is used to edit the text of a message 
    # that was sent by the bot in response to a callback query.
    #
    # await query.edit_message_text(text="show_truck_list()")

    await show_truck_list(query)

#    
# 
# Чтение парка грузовиков из базы данных
#
#  
async def show_truck_list(query):

    """
    Показывает список доступных грузовиков (только модель и номер).
    """

    try:

        bot2_database.cursor.execute("SELECT id, model, number FROM trucks")
        trucks = bot2_database.cursor.fetchall()

        bot2_logging.logger.info("🔄 Going over fetched trucks...")

        if trucks:

            buttons = []

            for truck_id, model, number in trucks:

                button_text = f"🚛 {model} | {number}"
                buttons.append([InlineKeyboardButton(button_text, callback_data=f"truck_{truck_id}")])
            
            reply_markup = InlineKeyboardMarkup(buttons + [[InlineKeyboardButton("🔙 Назад", callback_data="back_to_menu")]])
            await query.edit_message_text(text="Выберите грузовик:", reply_markup=reply_markup)

        else:
            await query.edit_message_text(text="В базе нет грузовиков.")

    except Exception as e:
        bot2_logging.logger.error("Ошибка при выводе автопарка: %s", e)

# 
# 
# Показывает подробную информацию по выбранному грузовику
# 
# 
async def truck_details_callback(update: Update, context: CallbackContext):

    """
    Показывает подробную информацию по выбранному грузовику.
    """

    query = update.callback_query

    await query.answer()

    data = query.data

    try:

        truck_id = data.split("_")[1]
        bot2_database.cursor.execute("SELECT * FROM trucks WHERE id = ?", (truck_id,))        
        truck = bot2_database.cursor.fetchone()

        if truck:
            overall_cal = truck[7]  # Калибровка
            details = (
                f"<b>🆔 ID:</b> {truck[0]}\n"
                f"<b>🚛 Модель:</b> {truck[1]}\n"
                f"<b>🔢 Номер:</b> {truck[2]}\n"
                f"<b>💼 ППЦ:</b> {truck[3]}\n"
                f"<b>⚖ Калибровка:</b> {overall_cal}\n"
                f"<b>📦 Общий объём:</b> {truck[6]}\n"
                f"<b>📝 Путевой лист:</b> {truck[8]}\n"
            )

            # 
            # Проверяем водителей
            # 
            if truck[4] and truck[5]:
                details += f"<b>👤 Водитель 1:</b> {truck[4]} (<i>{truck[11]}</i>)\n<b>👤 Водитель 2:</b> {truck[5]} (<i>{truck[12]}</i>)"
            else:
                details += f"<b>👤 Водитель:</b> {truck[4]} (<i>{truck[11]}</i>)"

            # 
            # Проверяем, назначен ли грузовик менеджеру
            # 
            if truck[9] is None:
                
                # 
                # Не назначен
                # 
                assign_markup = InlineKeyboardMarkup([
                    [InlineKeyboardButton("🟢 Выбрать водителя 1", callback_data=f"assign_truck_{truck[0]}_driver1")],
                    ([InlineKeyboardButton("🟢 Выбрать водителя 2", callback_data=f"assign_truck_{truck[0]}_driver2")]
                     if truck[5] else []),
                    [InlineKeyboardButton("📋 Копировать данные", callback_data=f"copy_truck_{truck[0]}")],
                    [InlineKeyboardButton("🔙 Назад", callback_data="view_trucks")]
                ])
                details += "\n\n❗ Машина не назначена менеджеру."
                await query.edit_message_text(text=details, reply_markup=assign_markup, parse_mode='HTML')
            
            else:

                # 
                # Уже назначен
                # 
                details += f"\n\n✅ Назначена менеджеру {truck[9]} с водителем {truck[10]}"
                reply_markup = InlineKeyboardMarkup([
                    [InlineKeyboardButton("📋 Копировать данные", callback_data=f"copy_truck_{truck[0]}")],
                    [InlineKeyboardButton("🔙 Назад", callback_data="view_trucks")]
                ])
                await query.edit_message_text(text=details, reply_markup=reply_markup, parse_mode='HTML')
        
        else:
            query.edit_message_text(text="❌ Грузовик не найден.")
    
    except Exception as e:
        bot2_logging.logger.error("❌ Ошибка при выводе деталей грузовика: %s", e)
        await query.edit_message_text(text="❌ Ошибка при получении данных о грузовике.")

# 
# 
# Копирует данные о грузовике в формате, нужном для отправки на нефтебазу.
# 
# 
async def copy_truck_callback(update: Update, context: CallbackContext):

    """
    Копирует данные о грузовике в формате, нужном для отправки на нефтебазу.
    """

    query = update.callback_query

    await query.answer()

    data = query.data

    try:
        truck_id = data.split("_")[2]

        bot2_database.cursor.execute("SELECT * FROM trucks WHERE id = ?", (truck_id,))
        truck = bot2_database.cursor.fetchone()

        if truck:

            # 
            # Пример заполнения данных водителя
            # 
            driver1_details = "19.05.1973 г.р., паспорт 4918 198895 выдан УМВД по Новгородской обл., 15.06.2018"
            driver1_registration = "Новгородская обл., Боровичский р-н, Боровичи, ул. Ленинградская д. 29, кв.64"

            calibration_raw = truck[7] if truck[7] else ""
            sections = calibration_raw.split("|")
            cal_breakdown = ""

            if len(sections) > 1:
                for i, sec in enumerate(sections, 1):
                    cal_breakdown += f"{i} - {sec.strip()} л.\n"
            else:
                cal_breakdown = f"1 - {calibration_raw.strip()} л.\n"

            details = (
                f"{truck[1]}  {truck[2]}\n"
                f"{truck[3]}\n"
                f"Водитель {truck[4]} {driver1_details}\n"
                f"Зарегистрирован: {driver1_registration}\n"
                f"Объём {truck[6]} л.\n"
                f"{cal_breakdown}"
                f"{truck[8]} от даты поездки"
            )

            await context.bot.send_message(chat_id=update.effective_chat.id, text=details)
            await query.edit_message_reply_markup(
                reply_markup=InlineKeyboardMarkup([[InlineKeyboardButton("🔙 Назад", callback_data="view_trucks")]])
            )
        else:
            query.edit_message_text(text="❌ Грузовик не найден.")

    except Exception as e:

        bot2_logging.logger.error("❌ Ошибка в copy_truck_handler: %s", e)
        await query.edit_message_text(text="❌ Ошибка при копировании данных.")

# 
# 
# Назначает выбранного водителя для грузовика.
# 
# 
async def assign_truck_callback(update: Update, context: CallbackContext):
   
    """
    Назначает выбранного водителя для грузовика.
    """
   
    query = update.callback_query

    await query.answer()

    data = query.data

    try:

        parts = data.split("_")
        truck_id = parts[2]
        driver_choice = parts[3]

        bot2_database.cursor.execute("SELECT driver1, driver2, model, number, calibration, driver1_phone, driver2_phone FROM trucks WHERE id = ?", (truck_id,))

        truck = bot2_database.cursor.fetchone()
        
        if truck:

            selected_driver = truck[0] if driver_choice == "driver1" else truck[1]
            selected_driver_phone = truck[5] if driver_choice == "driver1" else truck[6]

            manager = update.effective_user.first_name

            bot2_database.cursor.execute("UPDATE trucks SET assigned_manager = ?, assigned_driver = ? WHERE id = ?", (manager, selected_driver, truck_id))
            bot2_database.db.commit()

            overall_cal = truck[4]
            notification = (f"Ваша заявка принята под работу!\n\n"
                            f"Машина: {truck[2]} {truck[3]}\n"
                            f"Калибровка: {overall_cal}\n"
                            f"Выбран водитель: {selected_driver}\n"
                            f"Телефон водителя: {selected_driver_phone}\n"
                            f"Свяжитесь с логистом: +7 (999) 123-45-67")
            
            # 
            # The command context.bot.send_message(chat_id=update.effective_chat.id, text=notification) in your Telegram Bot 
            # sends a message to the chat specified by update.effective_chat.id, which is the chat where the callback query originated from. 
            # The message text is contained in the variable notification.
            # 
            await context.bot.send_message(chat_id=update.effective_chat.id, text=notification)

            await query.edit_message_text(
                text=f"Машина {truck_id} назначена менеджеру {manager} с водителем {selected_driver}.",
                reply_markup=InlineKeyboardMarkup([[InlineKeyboardButton("🔙 Назад", callback_data="view_trucks")]]),
                parse_mode='HTML'
            )
        else:
            await query.edit_message_text(text="❌ Ошибка при назначении. Грузовик не найден.")

    except Exception as e:

        bot2_logging.logger.error("❌ Ошибка в assign_truck_handler: %s", e)
        await query.edit_message_text(text="❌ Ошибка при обработке назначения.")

# 
# 
# Обработка "Посмотреть заявки"
# 
# 
async def contact_logistics_callback(update: Update, context: CallbackContext):

    query = update.callback_query

    await query.answer()  # Acknowledge the callback

    data = query.data

    await query.edit_message_text(
        text="Связаться с логистом можно по телефону +7 (999) 123-45-67.",
        reply_markup=InlineKeyboardMarkup([[InlineKeyboardButton("🔙 Назад", callback_data="back_to_menu")]]),
        parse_mode='HTML'
    )

# 
# 
# Обработка "Посмотреть заявки"
# 
# 
async def view_applications_callback(update: Update, context: CallbackContext):

    query = update.callback_query

    await query.answer()  # Acknowledge the callback

    data = query.data

    await bot2_ui.show_applications(query)

# 
# 
# Возврат в Главное меню
# 
# 
async def back_to_menu_callback(update: Update, context: CallbackContext):
    
    query = update.callback_query

    await query.answer()  # Acknowledge the callback

    data = query.data

    main_menu_text="👋 Привет!\nДобро пожаловать в логистический бот.\nВыберите действие:"

    await query.edit_message_text(text=main_menu_text, 
        reply_markup=bot2_ui.get_main_menu(),
        parse_mode='HTML' )