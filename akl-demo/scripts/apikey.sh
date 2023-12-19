#!/bin/bash

# Define the path and filename
PROFILE_PATH="${HOME}/.akeyless/profiles"
FILE="apikey.toml"

# Create the configuration block with the environment variable values
cat << EOF > "${PROFILE_PATH}/${FILE}"
  ["apikey"]
  access_id = '${adminAccessId}'
  access_key = '${adminAccessKey}'
  access_type = 'access_key'
EOF

# Output a dummy status 'completed' using jq
jq -n '{status: "completed"}'
