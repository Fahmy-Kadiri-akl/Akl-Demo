############## BEGIN - Install Akeyless API Gateway.  #######################

resource "time_sleep" "third_wait" {
  depends_on = [kubectl_manifest.issuer_letsencrypt_prod]
  create_duration = "120s"
}

resource "helm_release" "api_gateway" {
  depends_on =[time_sleep.third_wait, kubectl_manifest.issuer_letsencrypt_prod]
  name       = "akeyless-api-gateway"
  repository = "https://akeylesslabs.github.io/helm-charts"
  chart      = "akeyless-api-gateway"
  namespace  = kubernetes_namespace.namespace[var.namespaces[0]].metadata[0].name
  values = [<<EOF
  # Only overriding specific elements
replicaCount: 1
service:
  type: ClusterIP
ingress:
  enabled: true
  annotations:
    cert-manager.io/issuer: letsencrypt-prod
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/proxy-buffer-size: 8k
    nginx.ingress.kubernetes.io/proxy-buffers-number: "4"
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    # Large Header Support ----=v
    nginx.ingress.kubernetes.io/client-body-buffer-size: 64k
    nginx.ingress.kubernetes.io/client-header-buffer-size: 100k
    nginx.ingress.kubernetes.io/http2-max-header-size: 96k
    nginx.ingress.kubernetes.io/large-client-header-buffers: 4 100k
  rules:
    - servicePort: web
      hostname: "ui.${var.domain_suffix}"
    - servicePort: hvp
      hostname: "hvp.${var.domain_suffix}"
    - servicePort: legacy-api
      hostname: "rest.${var.domain_suffix}"
    - servicePort: api
      hostname: "api.${var.domain_suffix}"
    - servicePort: configure-app
      hostname: "conf.${var.domain_suffix}"
  tls: true
  certManager: true
version: "3.54.0"
env:
- name: CLUSTER_URL
  value: https://conf.${var.domain_suffix}
akeylessUserAuth:
  adminAccessId: "${akeyless_auth_method_api_key.api_auth.access_id}"
  adminAccessKey: "${akeyless_auth_method_api_key.api_auth.access_key}"
  clusterName: "Demo Gateway"
  initialClusterDisplayName: "Demo Gateway"
  allowedAccessIDs:
    - ${akeyless_auth_method_saml.saml_auth.access_id} groups=${var.akeyless_admins_group_name}
    - ${var.uid_access_id}
    - ${akeyless_auth_method_k8s.k8s_auth.access_id}
EOF
  ]
}
##############  END - Install Akeyless API Gateway.   #######################