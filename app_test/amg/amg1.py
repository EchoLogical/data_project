import requests
import json


def login_admin():
    url = "http://localhost:45001/login/admin"

    payload = json.dumps({
        "email": "aqma-hr3@avrist.com",
        "password": "Jakarta123",
        "language": "id"
    })
    headers = {
        'Content-Type': 'application/json'
    }

    response = requests.request("POST", url, headers=headers, data=payload)

    print(response.text)
