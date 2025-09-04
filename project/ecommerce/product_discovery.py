from tabulate import tabulate

from db_con.avr_illus import avr_illus_con


def output_table(rows, headers):
    if rows:
        table_output = tabulate(rows, headers=headers, tablefmt="grid")
        print(table_output)
        return table_output
    else:
        print("No data returned.")
        return None


@avr_illus_con
def fetch_data(db):
    rows, headers = db.execute_query("SELECT * FROM product_discovery_parameter pdp")
    data = output_table(rows, headers)


fetch_data()
 