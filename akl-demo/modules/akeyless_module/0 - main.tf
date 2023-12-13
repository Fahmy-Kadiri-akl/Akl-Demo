terraform {
  required_providers {
  akeyless = {
      version = ">= 1.3.6"
      source  = "akeyless-community/akeyless"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    google ={
        source = "hashicorp/google"
        version = ">= 4.44.1"
    }
  }
}

provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone = var.gcp_region
  credentials = var.gcp_key
}

provider "akeyless" {
  api_gateway_address = "https://api.akeyless.io"

  uid_login {
    access_id   = var.uid_access_id
    uid_token = var.uid_token
  }
}


provider "kubernetes" {
  config_path    = var.config_path
  config_context = var.config_context
}

provider "helm" {
  kubernetes {
    config_path = var.config_path
  }
}

provider "kubectl" {
  #   host                   = ${local.k8s_host}
  #   cluster_ca_certificate = ${local.cluster_ca_certificate}
  #   token                  = data.aws_eks_cluster_auth.main.token
  config_path      = var.config_path
  load_config_file = true
}