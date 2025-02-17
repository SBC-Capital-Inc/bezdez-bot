# 
# suvorov:
# Импортируем нужные модули
# 
import asyncio
import nest_asyncio
from   telegram.ext import Application, CommandHandler, CallbackQueryHandler
from   handlers     import show_truck_list

TOKEN = "8102152365:AAEoQKySTg9zJetP_3uClTOfp_RKReSZC54"

# 
# main
# 
async def main():

    app = Application.builder().token(TOKEN).build()

    # Command handlers
    app.add_handler(CommandHandler("start", show_truck_list))  # Now supports messages
    app.add_handler(CallbackQueryHandler(show_truck_list, pattern="^truck_list$"))

    print("✅ Бот запущен")
    await app.run_polling()

if __name__ == "__main__":
    nest_asyncio.apply()  # Исправляем ошибку "event loop already running"
    asyncio.run(main())
