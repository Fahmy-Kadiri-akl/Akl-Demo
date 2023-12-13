#create the namespaces in the new cluster, values taken from variables.tf in helm_module
resource "kubernetes_namespace" "namespace" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value
  }
}

#Install NGINX-Controller and manually overwrite the tcp values to port forward ports 22, 9000, and 9900 inbound
resource "helm_release" "ingress_controller" {
  name       = "quickstart"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.namespace[var.namespaces[0]].metadata[0].name

  values = [<<EOF
allowSnippetAnnotations: true
tcp:
  22: "${var.namespaces[0]}/ubuntu:22"
  9000: "${var.namespaces[0]}/akeyless-ztwa-dispatcher:9000"
  9900: "${var.namespaces[0]}/akeyless-sra-akeyless-sra:9900"
EOF
  ]
}

data "kubernetes_service" "nginx_ingress_lb" {

  metadata {
    name      = "${helm_release.ingress_controller.name}-ingress-nginx-controller"
    namespace = var.namespaces[0]
  }
}

data "google_dns_managed_zone" "existing_zone" {
  name = "${var.dns_zone_name}"  # Replace with the actual name of the existing zone
}

resource "google_dns_record_set" "a_record" {
  for_each     = toset(var.hostname)
  name         = "${each.value}.${var.domain_suffix}."
  managed_zone = data.google_dns_managed_zone.existing_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [data.kubernetes_service.nginx_ingress_lb.status.0.load_balancer.0.ingress.0.ip]
}

resource "time_sleep" "wait_5" {
  depends_on = [google_dns_record_set.a_record]

  create_duration = "10s"
}
#install Cert Manager
resource "helm_release" "cert_manager" {
  depends_on = [google_dns_record_set.a_record,time_sleep.wait_5 ]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "global.leaderElection.namespace"
    value = "cert-manager"
  }
    // Set the email address for ACME registration
  set {
    name  = "spec.acme.email"
    value = var.admin_email
  }
}

resource "time_sleep" "wait" {
  depends_on = [helm_release.ingress_controller, helm_release.cert_manager]

  create_duration = "10s"
}

resource "kubectl_manifest" "issuer_letsencrypt_prod" {
  depends_on = [
    time_sleep.wait
  ]
  count = 2 # creates two instances of the resource
  yaml_body = <<-EOF
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  annotations: {}
  name: letsencrypt-staging
  namespace: ${var.namespaces[count.index == 0 ? 0 : 3]}
spec:
  acme:
    email: ${var.admin_email}
    preferredChain: ""
    privateKeySecretRef:
      name: letsencrypt-staging
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    solvers:
      - http01:
          ingress:
            class: nginx
  EOF
}

# resource "kubernetes_service_account" "akeyless_auth" {
#   metadata {
#     name      = "akeyless-auth-sa"
#     namespace = "default"  # Change this to the desired namespace
#   }

#   automount_service_account_token = true
# }

# data "google_container_cluster" "my_cluster" {
#   name     = "${var.k8s_cluster_name}"    # Replace with your cluster name
#   location = "${var.gcp_region}" # Replace with your cluster location (zone or region)
#   }