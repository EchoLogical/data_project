from functools import wraps
from helper import mssql_con_helper

def dwh_con(function):
    @wraps(function)
    def wrapper(*args, **kwargs):
        server = 'SVRAVRPRDDWH01'
        port = 1433
        database = 'AVR_02_COMPASS_STAGING'
        username = 'usr_read_only'
        password = 'P@ssw0rd'

        db = mssql_con_helper.MSSQLConnection(server, port, database, username, password)
        try:
            db.connect()
            return function(db, *args, **kwargs)
        finally:
            db.close()
    return wrapper

@dwh_con
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
