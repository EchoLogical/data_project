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
    output_table(rows, headers)

    processed_data_list = []
    for row in rows:
        row_dict = dict(zip(headers, row))
        processed_data_list.append(row_dict)

    return processed_data_list





@avr_illus_con
def fetch_data(db):
    product_discovery_raw = get_data_product_discovery()
    for row in product_discovery_raw:
        check_data_usia(db, row)

    print(product_discovery_raw)

def check_data_usia(db, row_product_discovery):
    rows, headers = db.execute_query("select top 1 * from product_discovery_category where category = 'Usia'")
    category_usia = dict(zip(headers, rows))


fetch_data()
 