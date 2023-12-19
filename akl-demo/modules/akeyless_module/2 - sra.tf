############## BEGIN - Install Akeyless API Gateway.  #######################

resource "helm_release" "akeyless-sra" {
  count      = length(var.docker_repo_creds) > 0 ? 1 : 0
  depends_on =[time_sleep.third_wait, data.external.akeyless_csr, helm_release.api_gateway]
  name       = "akeyless-sra"
  repository = "https://akeylesslabs.github.io/helm-charts"
  chart      = "akeyless-sra"
  namespace  = kubernetes_namespace.namespace[var.namespaces[0]].metadata[0].name
  values = [<<EOF
dockerRepositoryCreds: ${var.docker_repo_creds}
apiGatewayURL: https://rest.akeyless.io
usernameSubClaim:
RDPusernameSubClaim:
SSHusernameSubClaim:
privilegedAccess:
  accessID: "${akeyless_auth_method_api_key.api_auth.access_id}"
  accessKey: "${akeyless_auth_method_api_key.api_auth.access_key}"
  allowedAccessIDs:
    - ${akeyless_auth_method_saml.saml_auth.access_id}
    - ${akeyless_auth_method_api_key.api_auth.access_id}
ztbConfig:
  enabled: true
  replicaCount: 1
  service:
    annotations: {}
    labels: {}
    type: ClusterIP
    port: 8888
  ingress:
    enabled: true
    annotations:
      cert-manager.io/issuer: letsencrypt-prod
      kubernetes.io/ingress.class: nginx
      nginx.ingress.kubernetes.io/ssl-redirect: "true"
      nginx.ingress.kubernetes.io/proxy-connect-timeout: "3600"
      nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
      nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
      nginx.ingress.kubernetes.io/proxy-buffer-size: "8k"
      nginx.ingress.kubernetes.io/proxy-buffers-number: "4"
      nginx.ingress.kubernetes.io/affinity: "cookie"
      nginx.ingress.kubernetes.io/session-cookie-expires: "172800"
      nginx.ingress.kubernetes.io/session-cookie-max-age: "172800"
    hostname: "bast.${var.domain_suffix}"
    tls: true
    certManager: true
ztpConfig:
  enabled: true
  replicaCount: 1
  service:
    type: ClusterIP
    port: 8080
  ingress:
    # enabled: true
    annotations: {}
    hostname:
    path: /
    tls: false
    certManager: false
sshConfig:
  enabled: true
  replicaCount: 1
  service:
    type: ClusterIP
  config:
    CAPublicKey: |
      "${data.external.issuer.result["CaPublicKey"]}"
EOF
  ]
}
##############  END - Install Akeyless API Gateway.   #######################