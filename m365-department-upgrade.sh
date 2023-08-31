#!/bin/bash
## Reqs:
# m365-login.sh executed
# jq

department="Sekcja Instruktorów"

TOKENS="${PWD}/.cli-m365-tokens.json"
MSAL="${PWD}/.cli-m365-msal.json"

ids=( $(docker run \
  --mount type=bind,source="${TOKENS}",dst=/home/cli-microsoft365/.cli-m365-tokens.json \
  --mount type=bind,source="${MSAL}",dst=/home/cli-microsoft365/.cli-m365-msal.json \
  m365pnp/cli-microsoft365 \
  m365 aad user list --department "${department}" --properties "id" | jq -r '.[] | .id') )

for (( i = 0; i < length; i++ ))
do
    docker run \
        --mount type=bind,source="${TOKENS}",dst=/home/cli-microsoft365/.cli-m365-tokens.json \
        --mount type=bind,source="${MSAL}",dst=/home/cli-microsoft365/.cli-m365-msal.json \
        m365pnp/cli-microsoft365 \
        m365 aad user set --objectId "${ids[i]}" --department "${department}"
done
