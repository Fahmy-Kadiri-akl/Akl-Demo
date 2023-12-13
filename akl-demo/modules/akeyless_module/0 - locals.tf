locals {
    cluster_name = "kadiri-cncf-standalone-1"
    #decoded_csr = base64decode(data.external.akeyless_csr.result["k8s_csr"])
    decoded_csr = data.external.akeyless_csr.result["k8s_csr"]
}