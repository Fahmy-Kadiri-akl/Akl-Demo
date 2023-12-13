#!/bin/bash

# Check for existing access ID in uid_auth.txt
access_id=$(grep '^p-' uid_auth.txt)

# If access ID does not exist, create one
if [ -z "$access_id" ]; then
    output=$(akeyless create-auth-method-universal-identity -n "/Demo/0 - Akeyless/UID_Auth" --ttl 15 --profile email)
    access_id=$(echo "$output" | awk -F': ' '/Access ID:/ {print $2}')
    echo $access_id > uid_auth.txt
fi

# Access ID exists, use the existing one (already read) & Generate UID token
output=$(akeyless uid-generate-token --auth-method-name "/Demo/0 - Akeyless/UID_Auth" --profile email)
uid_token=$(echo "$output" | awk -F': ' '/Token:/ {print $2}')
#associate UID auth to role
akeyless assoc-role-am --am-name "/Demo/0 - Akeyless/UID_Auth" -r /admin --profile email > /dev/null 2>&1

# Output both access_id and UID token in JSON format
jq -n --arg uid_access_id "$access_id" --arg uid_token "$uid_token" \
   '{uid_access_id: $uid_access_id, uid_token: $uid_token}'
