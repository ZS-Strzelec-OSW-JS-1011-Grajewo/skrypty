#!/bin/bash

sudo rm .cli-m365-tokens.json && touch .cli-m365-tokens.json && sudo chown 100:65533 .cli-m365-tokens.json
sudo rm .cli-m365-msal.json   && touch .cli-m365-msal.json   && sudo chown 100:65533 .cli-m365-msal.json

docker run \
    --mount type=bind,source="${PWD}"/.cli-m365-tokens.json,dst=/home/cli-microsoft365/.cli-m365-tokens.json \
    --mount type=bind,source="${PWD}"/.cli-m365-msal.json,dst=/home/cli-microsoft365/.cli-m365-msal.json \
    m365pnp/cli-microsoft365 m365 login
