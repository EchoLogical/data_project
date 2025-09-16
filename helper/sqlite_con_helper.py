import sqlite3

class SQLiteConnection:
    def __init__(self, database_path):
        """
        Inisialisasi koneksi ke SQLite
        """
        self.database_path = database_path
        self.conn = None
        self.cursor = None

    def connect(self):
        """Membuka koneksi ke database SQLite"""
        try:
            self.conn = sqlite3.connect(self.database_path)
            self.cursor = self.conn.cursor()
            print(f"Koneksi SQLite berhasil ke: {self.database_path}")
        except sqlite3.Error as e:
            print(f"Gagal koneksi ke database SQLite: {e}")
            self.conn = None

    def execute_query(self, query):
        """Menjalankan query SQL dan mengembalikan data + header"""
        if self.conn is None:
            print("Koneksi belum dibuka.")
            return None, None

        try:
            self.cursor.execute(query)
            rows = self.cursor.fetchall()
            headers = [desc[0] for desc in self.cursor.description] if self.cursor.description else []
            return rows, headers
        except sqlite3.Error as e:
            print(f"Error saat eksekusi query: {e}")
            return None, None

    def execute_non_query(self, query, params=None):
        """Menjalankan query yang tidak mengembalikan data (INSERT, UPDATE, DELETE)"""
        if self.conn is None:
            print("Koneksi belum dibuka.")
            return False

        try:
            if params:
                self.cursor.execute(query, params)
            else:
                self.cursor.execute(query)
            self.conn.commit()
            return True
        except sqlite3.Error as e:
            print(f"Error saat eksekusi non-query: {e}")
            self.conn.rollback()
            return False

    def close(self):
        """Menutup koneksi ke database"""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        print("Koneksi SQLite ditutup.")