from db_con.compass_dwh import dwh_con
from tabulate import tabulate

@dwh_con
def fetch_data(db):
    rows, headers = db.execute_query("SELECT TOP 1 * FROM TUWLTRDETAILPDTH")
    if rows:
        print(tabulate(rows, headers=headers, tablefmt="grid"))
    else:
        print("No data returned.")


fetch_data()
 