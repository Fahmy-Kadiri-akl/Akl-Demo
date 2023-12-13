data "external" "akeyless_csr" {
  depends_on = [helm_release.api_gateway]
  program = ["${path.module}/../../scripts/generate_csr.sh"]

  query = {
    GATEWAY_URL = "https://conf.${var.domain_suffix}"
  }
}