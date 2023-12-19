#!/bin/bash

# Use environment variables passed from Terraform
export USERNAME="AkeylessK8sAuth"
export GROUP="AkeylessAuth"
GATEWAY_URL="https://conf.demo1.cs.akeyless.fans"
ACCESS_ID="p-dbt1ndc8f9nvkm"
PRV_KEY="LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBdWZrYUJwZmFSVmMyckhEMWRnWk1Bc2x4d0orWDVhVW8waHgrcHpPTG5hMTlNY1ZDCnJjS1ZzUWpkMDVkMVplS3R4VVlnS2xCM015ZlIxWnN1cEN5bEFzcFllUFphdHhDUnJSOEFGYW1kMno3NitUTG0KUWNSaVdBeTZKR0FJeEhxMnpiS1JxdllLR2lmM1ltcjhlR2ZiNGcxKzdheVdCMVMyNFpjcWR4OTRsNDA2WktKcwo4bVJVa1crdjZhbnRPbFp3eFAwWnBrcFNxOVFrSnR1VjVLU2NEakp3VU9Vby90dFJtWXZLbkxNM1dsSVJOVGRPCnFQbzdRb0xnTVF0amxTV2F3OEJodHBWS1l1RXFSVEppR2lmOGNrK25BVFMwaGFvUlBDZnprUkJPK2MwK2hmbmgKMUhsbnJXeEVwVFhsVGdyOEVDYndqdFhaOVlLRzF4TmdPNTVvZFFJREFRQUJBb0lCQVFDZG1oZlBMSk1pSGtYTQpIekkxWWlLNlhlTFRuYXdKUmt6d3Vvc3V3UVQ1akJQRHdPcS8vRjRGR0lGOGxpYzhQN3lKcU9NTFdRT2JTNHlNCjNDVExwclgwUm14eG5qekVWUHRQWGkwaExvd0RTRDFDUUR0WDBzaVEyOEJIb1ViczB4M2w5Z1Z5ZjIyU092cHYKNGtDdy9Uc2ZOOWF3TG9rNkR6V291Z1dYekFqVFRMN1NrNXNMenpGNWxHQnljNnVIV2JXM1gvT1M4eVRxR1BZegpsT2cyMEhRT3NQWmtzdUlST1hNMkpTb0xsZnRWR3VQNzJoLzQ1L2RwS0o5azJLNUEzVWV2RGUyWlVkRmc5blhnCjRNbGNPV1hMenpwNEhzcHZITWo4UkJSVXNKS292K3hyUHNpL1JjQU1aM00zZmdxU3R6YUVQYVcvRytqSVhHNXYKc01IN0ZRdmhBb0dCQU5DRHU1QU5Xc1RzZG41UXM4c1UwY3hBYnRBaUFSQ0t4ZzdVS0cwMVF5Zi9wU0FRVlVLTwo4eUQyb3U4SUM1ZEx1V1BuSFhvMzBPTmdRT3hNLytKL3RYOXpyREZzLy92OHRnSzdSdXJLZElZRyt2WEF2dS9OCkhJOTFOdEl1Z05sOVFsaTFnMlRaQWhEQU0rekNtQVBhWDIxZ0RoVDllcTdpdWwvTHNjY3BvNjdaQW9HQkFPUlQKTmxsQThCeUg3akRvS2UzVFVXMTJpa3pnbjFmMmJaZStKZ0NkK1B5eVNtclJUTDRlVXNRUzJ4RE1DNllsUmdNVwpNcXA4eEtlWkJoUTVNRjZhWmI4MDduTGNCcFUvQlp0eStLU21LaTUzU3NNMEphN0F5ZWhnZm1IRkVWaEkzVHZ5CjZyN3hNYmFuUlVLeEM5d3FmMURHL0lyWVQwOFA1bVp3ODlkT2hmejlBb0dCQUpQUXZ4YzRrRjlIYmh6UG94VlYKTmdFQXNFMjF2V0YzcnozMTRvN0FrbEg1cFpwY1djU3NSK2pYVHR2NnJSVGRKcGlPejFQRDI3NUVqdUcxR0RUOQo2YkZuVSt0WjVRSkN2TmlrNEhvemVYVkYzNFIxMWlWekYwc1BnZ1J2MlFIVkRVS0xzcEM4VWYyRDg0dGt5NVQzCnFteUVDcGVRdGZiaVhkTHBPS2NDZXJuSkFvR0FNWmZ0ZHllR3YvdTZmZjcvbEh2UTlRREplM2RTeFExdXNvWUgKeFJ5TEI0QkdiN3MwZXhzbENSZTdZNE9laUNFU2V2c29XQ1d2cFdPMGtWSDJzcVhBc2U1eVdKcDRCNVRmeCtzSwpIT0ZHeWo3NUN6dFpjQUxLR0dKVk1URlgyaUJCaFpMMjhEQjlodG9BVGtNY2UxN3p0bnp5UDhwS043Y1JhWERoClZnUGxVSlVDZ1lBZG8yYTVSQ0k3NFlnTTJaNmhSd3o4TG9yYXZDMTJucFc1YUt4S2oxTXhmY3czcXhiaTJNcmUKcllHaldCVVhiQkpieWNRN1JlZUcrWlRWUDZnekVZV0ZSY0JGOE5KQVExZ29UZFkvWmxZUzQ2bUhCdnllcUluSApVdXRML2NkMmt4QUQxdFgxdnMwVExEM25HVWNhdGRsbHhRbkNZd2VqbkNQcktRL1JaS2thTkE9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo="
T_TOKEN="t-9395d4bb5edb5b1631dd834103f6adbc"

#cleanup old config:
akeyless delete-items -p "/k8s/" --token $T_TOKEN

# Generate CSR and User Key, suppressing all output except the needed JSON data
K8S_CSR=$(akeyless generate-csr -n /k8s/Clustername/csr/$USERNAME --generate-key --alg RSA2048 --common-name $USERNAME --gateway-url $GATEWAY_URL --org $GROUP --json --jq-expression ".data" --token $T_TOKEN | sed 's/NEW //g' | base64 | tr -d "\n") # 2>/dev/null)
USER_KEY=$(akeyless export-classic-key -n /k8s/Clustername/csr/$USERNAME --jq-expression ".key" --token $T_TOKEN | base64 ) #2>/dev/null)

# Apply CertificateSigningRequest, suppressing output
cat <<EOF | kubectl apply -f - # >/dev/null 2>&1
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

# Approve CSR, suppressing output
kubectl certificate approve $USERNAME # >/dev/null 2>&1

# Get CA Certificate, suppressing errors
CA_CERT=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.certificate-authority-data}' ) #2>/dev/null)

# Get User Certificate, suppressing errors
USER_CERT=$(kubectl get csr $USERNAME -o jsonpath='{.status.certificate}' ) # 2>/dev/null)  
akeyless create-certificate --name /k8s/Clustername/certificates/$USERNAME --certificate-data $USER_CERT --key-data $USER_KEY --expiration-event-in 30 --token $T_TOKEN # >/dev/null 2>&1

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
--disable-issuer-validation --token $T_TOKEN #>/dev/null 2>&1

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
--disable-issuer-validation true --token $T_TOKEN #>/dev/null 2>&1

# Output in JSON format using jq
#jq -n --arg k8s_csr "$K8S_CSR" --arg user_key "$USER_KEY" --arg ca_cert "$CA_CERT" '{"k8s_csr": $k8s_csr, "user_key": $user_key, "ca_cert": $ca_cert}'

# Output in JSON format using jq
jq -n --arg k8s_csr "$K8S_CSR" --arg user_key "$USER_KEY" \
  --arg t_token "$T_TOKEN" \
  --arg ca_cert "$CA_CERT" \
  '{"k8s_csr": $k8s_csr, "user_key": $user_key, "ca_cert": $ca_cert, "t_token": $t_token}'