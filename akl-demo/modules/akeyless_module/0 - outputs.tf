output "api_access_id" {
  value = akeyless_auth_method_api_key.api_auth.access_id
  sensitive = true
}

# output "api_access_key" {
#   value = akeyless_auth_method_api_key.api_auth.access_key
#   sensitive = true
# }

output "saml_access_id" {
  value = akeyless_auth_method_saml.saml_auth.access_id
}

output "cluster_ca_certificate" {
  value = data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate
}

output "cluster_endpoint" {
  value = data.google_container_cluster.my_cluster.endpoint
}

output "k8s_csr" {
  value = data.external.akeyless_csr.result["k8s_csr"]
}

output "user_key" {
  value = data.external.akeyless_csr.result["user_key"]
}

output "ca_cert" {
  value = data.external.akeyless_csr.result["ca_cert"]
}