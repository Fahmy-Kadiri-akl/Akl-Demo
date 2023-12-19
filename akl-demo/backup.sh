#!/bin/bash

NAMESPACE="akeyless"
BACKUP_FILE="secrets.yaml"

# Clear the backup file if it already exists
> "$BACKUP_FILE"

# Get list of secrets in the namespace and back them up
secrets=$(kubectl get secrets -n "$NAMESPACE" -o name)
for secret in $secrets; do
    secret_name=$(echo $secret | awk -F'/' '{print $2}')
    echo "---" >> "$BACKUP_FILE"
    kubectl get secret "$secret_name" -n "$NAMESPACE" -o yaml >> "$BACKUP_FILE"
done

echo "Backup completed. File: $BACKUP_FILE"
