resource "helm_release" "akeyless-ztwa" {
  count      = length(var.docker_repo_creds) > 0 ? 1 : 0
  depends_on =[time_sleep.third_wait, data.external.issuer, helm_release.akeyless-sra]
  name       = "akeyless-ztwa"
  repository = "https://akeylesslabs.github.io/helm-charts"
  chart      = "akeyless-zero-trust-web-access"
  namespace  = kubernetes_namespace.namespace[var.namespaces[0]].metadata[0].name
  values = [<<EOF
image:
  dockerRepositoryCreds: ${var.docker_repo_creds}
dispatcher:
  ingress:
    enabled: true
    hostname: ztwa.${var.domain_suffix}
    tls: true
    certManager: true
  service:
    type: ClusterIP
  config:
    apiGatewayURL: https://rest.akeyless.io
    clusterName: defaultCluster
    privilegedAccess:
      accessID: "${akeyless_auth_method_api_key.api_auth.access_id}"
      accessKey: "${akeyless_auth_method_api_key.api_auth.access_key}"
      allowedAccessIDs:
        - ${akeyless_auth_method_saml.saml_auth.access_id}
        - ${akeyless_auth_method_api_key.api_auth.access_id}
webWorker:
  config:
    policies: |
        {
          "policies": {
            "BlockAboutConfig": true,
            "BlockAboutAddons": true,
            "BlockAboutProfiles": true,
            "BlockAboutSupport": true,
            "DisableDeveloperTools": true,
            "DisableFirefoxAccounts": true,
            "DisablePasswordReveal": true,
            "DisablePrivateBrowsing": true,
            "DisableProfileImport": true,
            "DisableSafeMode": true,
            "OfferToSaveLogins": false,
            "OfferToSaveLoginsDefault": false,
            "PasswordManagerEnabled": false,
            "Proxy": {
              "Mode": "none",
              "Locked": true
            },
            "Preferences": {},
            "WebsiteFilter": {
              "Block": [
                "<all_urls>"
              ],
              "Exceptions": [
                "https://*.akeyless.io/*"
              ]
            }
          }
        }
EOF
  ]
}