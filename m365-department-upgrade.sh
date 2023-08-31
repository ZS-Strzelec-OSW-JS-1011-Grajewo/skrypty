#!/bin/bash
## Reqs:
# m365-login.sh executed
# jq

department="Sekcja Instruktorów"

DKR="docker run \
        --mount type=bind,source="${PWD}"/.cli-m365-tokens.json,dst=/home/cli-microsoft365/.cli-m365-tokens.json \
        --mount type=bind,source="${PWD}"/.cli-m365-msal.json,dst=/home/cli-microsoft365/.cli-m365-msal.json \
        m365pnp/cli-microsoft365"

ids=( $(${DKR} m365 aad user list --department "${department}" --properties "id" | jq -r '.[] | .id') )
length=${#ids[@]}

for (( i = 0; i < length; i++ ))
do
    ${DKR} m365 aad user set --objectId "${ids[i]}" --department "${department}"
done
