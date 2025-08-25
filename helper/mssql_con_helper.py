import pymssql

class MSSQLConnection:
    def __init__(self, server, port, database, username, password):
        """
        Inisialisasi koneksi ke SQL Server
        """
        self.server = server
        self.port = port
        self.database = database
        self.username = username
        self.password = password
        self.conn = None
        self.cursor = None

    def connect(self):
        """Membuka koneksi ke database"""
        try:
            self.conn = pymssql.connect(self.server, self.username, self.password, self.database, port=self.port)
            self.cursor = self.conn.cursor()
            print("Koneksi berhasil!")
        except pymssql.DatabaseError as e:
            print(f"Gagal koneksi ke database: {e}")
            self.conn = None

    def execute_query(self, query):
        """Menjalankan query SQL dan mengembalikan data + header"""
        if self.conn is None:
            print("Koneksi belum dibuka.")
            return None, None

        try:
            self.cursor.execute(query)
            rows = self.cursor.fetchall()
            headers = [desc[0] for desc in self.cursor.description]
            return rows, headers
        except pymssql.DatabaseError as e:
            print(f"Error saat eksekusi query: {e}")
            return None, None

    def close(self):
        """Menutup koneksi ke database"""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        print("Koneksi ditutup.")

