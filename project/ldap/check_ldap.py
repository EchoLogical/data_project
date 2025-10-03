from ldap3 import Server, Connection, ALL, NTLM, SUBTREE

# LDAP settings
LDAP_SERVER = 'LDAP://10.50.1.10'
LDAP_USER = 'DAPP005@avrist.net'
LDAP_PASSWORD = '#Avr!st46$^'
LDAP_SEARCH_BASE = 'OU=Avrist Users,DC=avrist,DC=net'


def get_ldap_data_from_username(sam_account_name ):
    try:
        server = Server(LDAP_SERVER, get_info=ALL)
        conn = Connection(server, user=LDAP_USER, password=LDAP_PASSWORD, auto_bind=True)

        if not conn.bind():
            print(f"Failed to connect to LDAP server: {conn.result['description']}")
            return
        
        print("Successfully connected to the LDAP server.")

        search_filter = f"(sAMAccountName={sam_account_name})"
        conn.search(
            search_base=LDAP_SEARCH_BASE,
            search_filter=search_filter,
            search_scope=SUBTREE,
            attributes=[
                # Atribut yang pasti ada di kebanyakan AD
                'cn', 'sAMAccountName', 'displayName', 'userPrincipalName',
                'givenName', 'sn', 'mail', 'memberOf', 'department', 'title',
                'company', 'telephoneNumber', 'mobile', 'description',
                'whenCreated', 'whenChanged', 'userAccountControl'
            ]
        )

        # Process search results
        entries = conn.entries
        for entry in entries:
            print(entry)

        # Unbind the connection
        conn.unbind()

    except Exception as e:
        print(f"An error occurred: {e}")


get_ldap_data_from_username("DSNP124")