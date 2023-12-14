data "external" "akeyless_csr" {
  depends_on = [helm_release.api_gateway]
  program = ["${path.module}/../../scripts/generate_csr.sh"]

  query = {
    GATEWAY_URL = "https://conf.${var.domain_suffix}"
    K8S_AUTH_METHOD = "${akeyless_auth_method_k8s.k8s_auth.access_id}"
    K8S_PRIVATE_KEY = "${akeyless_auth_method_k8s.k8s_auth.private_key}"
  }
}

resource "helm_release" "akeyless-k8s-injector" {
  depends_on = [data.external.akeyless_csr]
  name       = "akeyless-k8sinjection"
  repository = "https://akeylesslabs.github.io/helm-charts"
  chart      = "akeyless-secrets-injection"
  namespace = kubernetes_namespace.namespace[var.namespaces[2]].metadata[0].name
  set {
    name  = "env.AKEYLESS_ACCESS_ID"
    value = akeyless_auth_method_k8s.k8s_auth.access_id
  }

  set {
    name  = "env.AKEYLESS_ACCESS_TYPE"
    value = "k8s"
  }

  set {
    name  = "env.AKEYLESS_API_GW_URL"
    value = "https://api.${var.domain_suffix}"
  }

  set {
    name  = "env.AKEYLESS_K8S_AUTH_CONF_NAME"
    value = "demo_k8s_config"
  }
}