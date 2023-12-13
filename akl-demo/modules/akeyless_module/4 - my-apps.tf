# resource "null_resource" "install_postgresql" {
#   depends_on = [kubectl_manifest.issuer_letsencrypt_prod]
#   provisioner "local-exec" {
#     command = <<-EOT
#       helm install postgresql -n my-apps \
#         --set auth.username=RootAdmin \
#         --set auth.postgresPassword=MyPassword \
#         oci://registry-1.docker.io/bitnamicharts/postgresql 
#     EOT
#   }
# }

resource "helm_release" "install_postgresql" {
  depends_on = [kubectl_manifest.issuer_letsencrypt_prod]

  name       = "postgresql"
  namespace  = "my-apps"
  chart      = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"

  set {
    name  = "auth.username"
    value = "RootAdmin"
  }

  set {
    name  = "auth.postgresPassword"
    value = "MyPassword"
  }
}