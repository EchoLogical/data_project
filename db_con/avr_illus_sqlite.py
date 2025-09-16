from functools import wraps
from helper import sqlite_con_helper

def sqlite_avr_illus_con(function):
    @wraps(function)
    def wrapper(*args, **kwargs):
        database_path = 'D:/Faisal/database_query/pythonProject/sqlite/ecommerce.sqlite'

        db = sqlite_con_helper.SQLiteConnection(database_path)
        try:
            db.connect()
            return function(db, *args, **kwargs)
        finally:
            db.close()
    return wrapper

@sqlite_avr_illus_con
def test_connection(db):
    try:
        rows, headers = db.execute_query("SELECT 1")
        if rows:
            print("Koneksi berhasil dan query berhasil dieksekusi.")
        else:
            print("Koneksi berhasil tetapi query tidak mengembalikan hasil.")
    except Exception as e:
        print(f"Terjadi kesalahan saat menguji koneksi: {e}")

test_connection()
