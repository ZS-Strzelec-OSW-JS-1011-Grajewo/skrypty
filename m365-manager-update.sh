#!/bin/bash
## Reqs:
# az cli
# m365-login.sh executed
# jq

# zmienić --filter w linii 10
# zmienić --managerUserName w linii 18

ids=( $(az ad user list --filter "department eq 'Pluton 1 Drużyna 1'" | jq '.[] | .id, .givenName, .surname' | sed -n '1~3p' | sed 's/"//g') )
length=${#ids[@]}

for (( i = 0; i < length; i++ ))
do
    docker run \
        --mount type=bind,source="${PWD}"/.cli-m365-tokens.json,dst=/home/cli-microsoft365/.cli-m365-tokens.json \
        --mount type=bind,source="${PWD}"/.cli-m365-msal.json,dst=/home/cli-microsoft365/.cli-m365-msal.json \
        m365pnp/cli-microsoft365 m365 aad user set --objectId "${ids[i]}" --managerUserName "l.zyskowski@strzelec.grajewo.pl"
done
