import sqlite3
import logging

logger = logging.getLogger(__name__)

# 
# Создает таблицы, если их нет
# 
async def check_database():

    """Создает таблицы, если их нет"""

    conn = sqlite3.connect("trucks.db")
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS trucks (
            id INTEGER PRIMARY KEY,
            model TEXT,
            number TEXT,
            driver TEXT,
            phone TEXT,
            fuel_capacity INTEGER,
            calibration TEXT
        )
    """)

    conn.commit()
    conn.close()

    logger.info("База данных проверена")

# 
# Возвращает список всех маши
# 
async def get_trucks():

    """Возвращает список всех машин"""

    conn = sqlite3.connect("trucks.db")
    cursor = conn.cursor()

    cursor.execute("SELECT id, model, number FROM trucks")
    trucks = cursor.fetchall()

    conn.close()

    return trucks

#
# Возвращает информацию о машине
# 
async def get_truck_details(truck_id):

    """Возвращает информацию о машине"""
    
    conn = sqlite3.connect("trucks.db")
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM trucks WHERE id=?", (truck_id,))
    truck = cursor.fetchone()

    conn.close()

    return truck
