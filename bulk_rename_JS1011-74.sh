#!/bin/bash
## Reqs:
# az cli
# jq
IFS=$'\n'
ids=( $(az ad user list | jq '.[] | .id, .givenName, .surname' | sed -n '1~3p' | sed 's/"//g') )
first_name=( $(az ad user list | jq '.[] | .id, .givenName, .surname' | sed -n '2~3p' | sed 's/"//g' ) )
last_name=( $(az ad user list | jq '.[] | .id, .givenName, .surname' | sed -n '3~3p' | sed 's/"//g') )

length=${#ids[@]}

for (( i = 0; i < length; i++ ))
do
    az ad user update --id "${ids[i]}" --display-name "${last_name[i]^^} ${first_name[i]}"
done
