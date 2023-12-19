#!/bin/bash

eval "$(jq -r '@sh "KEYNAME=\(.KEYNAME) ISSUERNAME=\(.ISSUERNAME) UID_TOKEN=\(.UID_TOKEN)"')"

# Set KeyName and IssuerName
KEYNAME="${KEYNAME}"
ISSUERNAME="${ISSUERNAME}"
uid_token="${UID_TOKEN}"
# Attempt to create the DFC key
akeyless create-dfc-key --name "$KEYNAME" --alg RSA2048 --uid-token $uid_token > /dev/null 2>&1
create_status=$?

# If the DFC key didn't exist and was created, then create the SSH cert issuer
if [ $create_status -ne 0 ]; then
    akeyless create-ssh-cert-issuer --name "$ISSUERNAME" --signer-key-name "$KEYNAME" --allowed-users 'ubuntu,root' --ttl 300 --uid-token $uid_token > /dev/null 2>&1
fi

# Retrieve the public key and output in JSON format
CaPublicKey=$(akeyless get-rsa-public --name "$KEYNAME" --uid-token $uid_token  | sed -n '/ssh-rsa/,/- PEM/p' | grep 'ssh-rsa' | sed 's/- SSH: //')
jq -n --arg CaPublicKey "$CaPublicKey" '{CaPublicKey: $CaPublicKey}'
