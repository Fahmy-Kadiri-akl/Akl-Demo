#!/bin/bash

# Set KeyName and IssuerName
KeyName="${KeyName}"
IssuerName="${IssuerName}"

# Attempt to create the DFC key
akeyless create-dfc-key --name "$KeyName" --alg RSA2048 --profile email > /dev/null 2>&1
create_status=$?

# If the DFC key didn't exist and was created, then create the SSH cert issuer
if [ $create_status -ne 0 ]; then
    akeyless create-ssh-cert-issuer --name "$IssuerName" --signer-key-name "$KeyName" --allowed-users 'ubuntu,root' --ttl 300 --profile email > /dev/null 2>&1
fi

# Retrieve the public key and output in JSON format
CaPublicKey=$(akeyless get-rsa-public --name "$KeyName" --profile email | sed -n '/ssh-rsa/,/- PEM/p' | grep 'ssh-rsa' | sed 's/- SSH: //')
jq -n --arg CaPublicKey "$CaPublicKey" '{CaPublicKey: $CaPublicKey}'
