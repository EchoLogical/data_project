@dwh_con
def fetch_data(db):
    rows, headers = db.execute_query("""
        
    """.format(policy_no=policy_no))
    if rows:
        print(tabulate(rows, headers=headers, tablefmt="grid"))
    else:
        print("No data returned.")


fetch_data()