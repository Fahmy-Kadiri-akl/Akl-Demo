data "external" "akeyless_config" {
  depends_on = [helm_release.api_gateway]
  program = ["${path.module}/../../scripts/apikey.sh"]

  query = {
    adminAccessId  = akeyless_auth_method_api_key.api_auth.access_id
    adminAccessKey = akeyless_auth_method_api_key.api_auth.access_key
  }
}

data "external" "issuer" {
  program = ["${path.module}/../../scripts/issuer.sh"]
  depends_on = [data.external.akeyless_config]
  query = {
    KEYNAME    = local.KeyName
    ISSUERNAME = local.IssuerName
    UID_TOKEN = local.token
    dummy_data = data.external.akeyless_config.result["status"]
  }
}

data "external" "akeyless_csr" {
  depends_on = [data.external.akeyless_config]
  program = ["${path.module}/../../scripts/generate_csr.sh"]

  query = {
    GATEWAY_URL = "https://conf.${var.domain_suffix}"
    K8S_AUTH_METHOD = "${akeyless_auth_method_k8s.k8s_auth.access_id}"
    K8S_PRIVATE_KEY = "${akeyless_auth_method_k8s.k8s_auth.private_key}"
    UID_TOKEN = local.token
    dummy_data = data.external.akeyless_config.result["status"]
    #T_TOKEN = var.script_output_t_token
  }
}
