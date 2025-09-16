from tabulate import tabulate

from db_con.avr_illus import avr_illus_con
from db_con.avr_illus_sqlite import sqlite_avr_illus_con


def output_table(rows, headers):
    if rows:
        table_output = tabulate(rows, headers=headers, tablefmt="grid")
        print(table_output)
        return table_output
    else:
        print("No data returned.")
        return None


@sqlite_avr_illus_con
def get_data_product_discovery(db):
    rows,headers = db.execute_query("SELECT * FROM ecommerce_needs_discovery")
    data = output_table(rows, headers)


@avr_illus_con
def fetch_data(db):
    rows, headers = db.execute_query("SELECT * FROM product_discovery_parameter pdp")
    data = output_table(rows, headers)



get_data_product_discovery()
 