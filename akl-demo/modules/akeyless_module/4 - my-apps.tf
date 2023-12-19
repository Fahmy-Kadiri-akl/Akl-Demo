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

resource "helm_release" "install_mysql" {
  depends_on = [helm_release.install_postgresql]

  name       = "mysql"
  namespace  = "my-apps"
  chart      = "mysql"
  repository = "https://charts.bitnami.com/bitnami"

  set {
    name  = "auth.username"
    value = "RootAdmin"
  }

  set {
    name  = "auth.rootPassword"
    value = "MyPassword"
  }
}