import logging
import sqlite3

logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# 
# Работа с базой данных
# 
try:
    db = sqlite3.connect("trucks.db", check_same_thread=False)
    cursor = db.cursor()

except Exception as e:
    logger.error("Ошибка подключения к базе данных: %s", e)
    raise

# 
# Инициализация базы данных - SQLLite
# 
def init_db():
    try:
        logger.info("🔄 Initializing table trucks")
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS trucks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                model TEXT,
                number TEXT UNIQUE,
                ppc TEXT,
                driver1 TEXT,
                driver2 TEXT,
                tank_capacity REAL,
                calibration TEXT,
                trips TEXT,
                assigned_manager TEXT DEFAULT NULL,
                assigned_driver TEXT DEFAULT NULL,
                driver1_phone TEXT,
                driver2_phone TEXT
            )
        """)
        logger.info("🔄 Initializing table applications")
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS applications (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                company TEXT,
                manager TEXT,
                delivery_date TEXT,
                fueling_date TEXT,
                fueling_place TEXT,
                price REAL,
                submission_datetime TEXT,
                status TEXT DEFAULT 'new'
            )
        """)
        logger.info("🔄 Initializing table clients")
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS clients (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT UNIQUE
            )
        """)
        db.commit()
        logger.info("✅ База данных и таблицы успешно инициализированы.")

    except Exception as e:
        logger.error("❌ Ошибка инициализации базы данных: %s", e)
        db.rollback()

#
# Заполнение таблицы "клиенты"
#
def add_clients(clients_data):

    """
    Заполняет таблицу clients тестовыми клиентами, если она пуста.
    """

    try:
        for client in clients_data:
            logger.info(f"🔄 Initializing client: {client} 🛠️")
            cursor.execute("INSERT OR IGNORE INTO clients (name) VALUES (?)", client)
        
        db.commit()
        logger.info("✅ Клиенты успешно инициализированы.")

    except Exception as e:
        logger.error("❌ Ошибка инициализации клиентов: %s", e)
        db.rollback()

#
# Добавляет грузовики в таблицу trucks, если их ещё нет
#
def add_trucks(trucks_data):
    
    """
    Добавляет грузовики в таблицу trucks, если их ещё нет.
    """

    added_count = 0

    for truck in trucks_data:
        try:

            cursor.execute("SELECT * FROM trucks WHERE number = ?", (truck[1],))
            existing_truck = cursor.fetchone()

            if not existing_truck:
                logger.info(f"🔄 Inserting truck: {truck} 🛠️")
                cursor.execute("""
                    INSERT INTO trucks (model, number, ppc, driver1, driver2, tank_capacity, calibration, trips, driver1_phone, driver2_phone)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, truck)
                added_count += 1
                db.commit()
                logger.info(f"✅ Машина {truck[1]} добавлена в базу.")

            else:
                logger.info(f"⚠️ Машина с номером {truck[1]} уже существует в базе.")

        except Exception as e:
            logger.error("❌ Ошибка добавления машины %s: %s", truck[1], e)
            db.rollback()

    logger.info(f"✅ Добавлено {added_count} новых машин в базу.")

    return added_count
