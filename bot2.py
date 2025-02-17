
# 
# https://pypi.org/project/python-telegram-bot/
# https://pypi.org/project/python-telegram-bot/#installing
# 

# 
# https://core.telegram.org/bots/samples
# https://github.com/python-telegram-bot/python-telegram-bot
# https://github.com/python-telegram-bot/python-telegram-bot/wiki/Introduction-to-the-API
# https://github.com/python-telegram-bot/python-telegram-bot/wiki/Extensions---Your-first-Bot
# 

from telegram.ext import ApplicationBuilder, CommandHandler, CallbackQueryHandler

import bot2_config
import bot2_logging
import bot2_handlers 
import bot2_database

# 
# 
# Запуск программы
# 
# 
if __name__ == '__main__':

    # 
    # Подключаемся к базе данных и добавляем данные, если она пустая
    # 
    bot2_database.init_db()
    bot2_database.add_clients(bot2_config.CLIENTS_DATA)
    bot2_database.add_trucks(bot2_config.TRUCKS_DATA)

    # 
    # Создание бота
    # 
    app = ApplicationBuilder().token(bot2_config.TOKEN).build()
    
    # 
    # Обработчик команды /start
    # 
    app.add_handler(CommandHandler('start', bot2_handlers.welcome_cmd))

    # 
    # Обработчики нажатия кнопок операций с грузовиками
    # 
    app.add_handler(CallbackQueryHandler(bot2_handlers.show_trucks_callback,   pattern="^view_trucks$"))
    app.add_handler(CallbackQueryHandler(bot2_handlers.truck_details_callback, pattern="^truck_\\d+$"))
    app.add_handler(CallbackQueryHandler(bot2_handlers.copy_truck_callback, pattern="^copy_truck_\\d+$"))
    app.add_handler(CallbackQueryHandler(bot2_handlers.assign_truck_callback,  pattern="^assign_truck_\\d+_driver[12]$"))

    # 
    # Обработка "Связаться с логистом"
    # 
    app.add_handler(CallbackQueryHandler(bot2_handlers.contact_logistics_callback,  pattern="^contact_logistics$"))

    # 
    # Обработка "Посмотреть заявки"
    #     
    app.add_handler(CallbackQueryHandler(bot2_handlers.view_applications_callback,  pattern="^view_applications$"))

    # 
    # Обработчики нажатия кнопки "Назад"
    # 
    app.add_handler(CallbackQueryHandler(bot2_handlers.back_to_menu_callback,  pattern="^back_to_menu$"))
    
    bot2_logging.logger.info("🔥 Бот запущен...")

    # 
    # Запуск цикла обработки сообщения
    # 
    app.run_polling()
    