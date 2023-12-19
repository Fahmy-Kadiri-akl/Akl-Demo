#!/bin/bash

# Use environment variables passed from Terraform
export USERNAME="AkeylessK8sAuth"
export GROUP="AkeylessAuth"
GATEWAY_URL="${GATEWAY_URL}"
ACCESS_ID="${K8S_AUTH_METHOD}"
PRV_KEY="${K8S_PRIVATE_KEY}"
uid_token="${UID_TOKEN}"

#cleanup old config:
akeyless delete-items -p "/k8s/" --profile apikey >/dev/null 2>&1

# Generate CSR and User Key, suppressing all output except the needed JSON data
K8S_CSR=$(akeyless generate-csr -n /k8s/Clustername/csr/$USERNAME --generate-key --alg RSA2048 --common-name $USERNAME --gateway-url $GATEWAY_URL --org $GROUP --json --jq-expression ".data" --profile apikey | sed 's/NEW //g' | base64 | tr -d "\n")
USER_KEY=$(akeyless export-classic-key -n /k8s/Clustername/csr/$USERNAME --jq-expression ".key" --profile apikey | base64)

# Apply CertificateSigningRequest, suppressing output
cat <<EOF | kubectl apply -f - >/dev/null 2>&1
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${USERNAME}
spec:
  groups:
  - system:authenticated
  request: ${K8S_CSR}
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF
# Get CA Certificate, suppressing errors
CA_CERT=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.certificate-authority-data}')

# Approve CSR, suppressing output
kubectl certificate approve $USERNAME  >/dev/null 2>&1

# Get User Certificate, suppressing errors
USER_CERT=$(kubectl get csr $USERNAME -o jsonpath='{.status.certificate}' )  
akeyless create-certificate --name /k8s/Clustername/certificates/$USERNAME --certificate-data $USER_CERT --key-data $USER_KEY --expiration-event-in 30 --profile apikey >/dev/null 2>&1

HOST=$(kubectl config view --minify --output 'jsonpath={.clusters[0].cluster.server}')

# Apply ClusterRoleBinding, suppressing output
cat <<EOF | kubectl apply -f - >/dev/null 2>&1
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: role-tokenreview-binding
  namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
- kind: User
  name: ${USERNAME}
  namespace: default
EOF

akeyless gateway-create-k8s-auth-config \
--name demo_k8s_config \
--gateway-url $GATEWAY_URL \
--access-id $ACCESS_ID \
--signing-key $PRV_KEY \
--k8s-auth-type certificate \
--k8s-host $HOST \
--k8s-client-certificate $USER_CERT \
--k8s-client-key $USER_KEY \
--k8s-ca-cert $CA_CERT \
--disable-issuer-validation --profile apikey >/dev/null 2>&1

akeyless gateway-update-k8s-auth-config \
--name demo_k8s_config \
--new-name demo_k8s_config \
--gateway-url $GATEWAY_URL \
--access-id $ACCESS_ID \
--signing-key $PRV_KEY \
--k8s-auth-type certificate \
--k8s-host $HOST \
--k8s-client-certificate $USER_CERT \
--k8s-client-key $USER_KEY \
--k8s-ca-cert $CA_CERT \
--disable-issuer-validation true --profile apikey >/dev/null 2>&1

# Output in JSON format using jq
jq -n --arg k8s_csr "$K8S_CSR" --arg user_key "$USER_KEY" \
  --arg t_token "$T_TOKEN" \
  --arg ca_cert "$CA_CERT" \
  '{"k8s_csr": $k8s_csr, "user_key": $user_key, "ca_cert": $ca_cert, "t_token": $t_token}'

