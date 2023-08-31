from os import environ
from smsapi.client import SmsApiPlClient
from subprocess import run

import csv
import json

## UWAGA
# Przed rozpoczęciem umieść w folderze plik .csv po utworzeniu kont w panelu admina M365

## Uwierzytelnienie w SMS API
if "SMS_API_TOKEN" not in environ:
    print("Brak ustawionego parametru SMS_API_TOKEN")
    exit(1)
token = environ.get("SMS_API_TOKEN")
client = SmsApiPlClient(access_token=token)

## Wyciągnięcie maili i haseł z pliku .csv
with open("users.csv", newline="") as csvfile:
    records = csv.reader(csvfile, delimiter=",", quotechar="|")
    user_passwords = {entry[1]: entry[2] for entry in records}
    user_passwords.pop("Username")

# Wyciągnięcie numeru telefonów z AAD
mobile_phones = {}

for rifleman in user_passwords.keys():
    raw_output = run(
        [
            "az",
            "ad",
            "user",
            "show",
            "--id",
            rifleman,
        ],
        capture_output=True,
    )
    try:
        number = json.loads(raw_output.stdout.decode())["mobilePhone"]
        mobile_phones.update({rifleman: number})
    except AttributeError:
        print(f"Couldn't decode {rifleman} phone number")
        break

# Wysłanie SMSów przez SMS API
for rifleman, password in user_passwords.items():
    if mobile_phones[rifleman] is not None:
        print(
            f"Czołem! Twój mail do https://teams.microsoft.com/ to {rifleman} a jednorazowe hasło to {password}"
        )
        client.sms.send(
            to=mobile_phones[rifleman],
            message=f"Czołem! Twój mail do https://teams.microsoft.com/ to {rifleman} a jednorazowe hasło to {password}",
            max_parts=1,
        )
