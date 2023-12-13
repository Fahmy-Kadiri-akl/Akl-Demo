#!/bin/bash

admin_email="$ADMIN_EMAIL"
admin_password="$ADMIN_PASSWORD"
# Define directory, filenames, and OS information
templates_directory="templates"
ak_api_gw_values_filename="akeyless_api_gw_values.yaml"
ak_k8s_secret_injector_yaml_name="akeyless_k8s_Secret_injector.yaml"
OS_MACHINE="$(uname -s)_$(uname -m)"
CLI_PATH="${HOME}/.akeyless/bin"
CLI="$CLI_PATH/akeyless"

# Function to download a file, always overwriting the existing one
download_and_overwrite() {
    curl -o "$2" "$1" >/dev/null 2>&1
}

# Function to download and install Akeyless CLI if not present
download_and_install_akeyless() {
    mkdir -p "$CLI_PATH"
    case $OS_MACHINE in
        "Linux_x86_64")
            URL="https://akeyless-cli.s3.us-east-2.amazonaws.com/cli/latest/production/cli-linux-amd64"
            curl -o "$CLI" "$URL" >/dev/null 2>&1
            ;;
        "Linux_aarch64")
            URL="https://akeyless-cli.s3.us-east-2.amazonaws.com/cli/latest/production/cli-linux-arm64"
            curl -o "$CLI" "$URL" >/dev/null 2>&1
            ;;
        "Darwin_x86_64"|"Darwin_arm64")
            if ! command -v akeyless &> /dev/null; then
                brew install akeyless >/dev/null 2>&1
            fi
            ;;
    esac
    chmod +x "$CLI" >/dev/null 2>&1
    "$CLI" --init >/dev/null 2>&1
}

# Check if Akeyless CLI exists and download if not
if [ ! -f "$CLI" ] || ! command -v akeyless &> /dev/null; then
    download_and_install_akeyless
    profile_file="${HOME}/.$(basename $SHELL)rc"
    grep -q "$CLI_PATH" "$profile_file" || echo "export PATH=\$PATH:$CLI_PATH" >> "$profile_file"
fi

# Configure CLI profile
"$CLI" configure --access-type password --admin-email "$ADMIN_EMAIL" --admin-password "$ADMIN_PASSWORD" --profile email >/dev/null 2>&1

# Create the templates directory if it doesn't exist
mkdir -p "$templates_directory"

# Download files using the function
download_and_overwrite "https://raw.githubusercontent.com/akeylesslabs/helm-charts/main/charts/akeyless-api-gateway/values.yaml" "$templates_directory/akeyless_api_gw_values.yaml"
download_and_overwrite "https://raw.githubusercontent.com/akeylesslabs/helm-charts/main/charts/akeyless-k8s-secrets-injection/values.yaml" "$templates_directory/akeyless_k8s_Secret_injector.yaml"
download_and_overwrite "https://raw.githubusercontent.com/akeylesslabs/helm-charts/main/charts/akeyless-secure-remote-access/values.yaml" "$templates_directory/akeyless_sra_values.yaml"
download_and_overwrite "https://raw.githubusercontent.com/akeylesslabs/helm-charts/main/charts/akeyless-zero-trust-web-access/values.yaml" "$templates_directory/akeyless_ztwa_values.yaml"
download_and_overwrite "https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/charts/ingress-nginx/values.yaml" "$templates_directory/ingress-nginx_values.yaml"
download_and_overwrite "https://raw.githubusercontent.com/cert-manager/cert-manager/master/deploy/charts/cert-manager/values.yaml" "$templates_directory/cert-manager_values.yaml"

# Check OS and install Google Cloud SDK and kubectl if appropriate
case $OS_MACHINE in
    "Linux_x86_64"|"Linux_aarch64"|"Darwin_x86_64"|"Darwin_arm64")
        which gcloud >/dev/null || install_google_cloud_sdk
        which kubectl >/dev/null || install_kubectl
        ;;
esac

# Check if jq is installed and install if not
which jq >/dev/null || install_jq

# Output JSON
jq -n '{dummy_output: "completed"}'
