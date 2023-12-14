variable "admin_email" {
  description = "Email Admin Password"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Email Admin Password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "uid_access_id" {
  description = "UID Access Id"
  type        = string
}

variable "uid_token" {
  description = "UID Access Id"
  type        = string
  sensitive   = true
}

#Okta Variables
variable "okta_org_name" {
  description = "The Okta Org Name"
  type        = string
}

variable "okta_base_url" {
  description = "The Okta Base URL"
  type        = string
}

variable "okta_api_token" {
  description = "The Okta API Token"
  type        = string
  sensitive   = true
}

variable "domain_suffix" {
  description = "Domain Suffix"
  type        = string
  sensitive   = true
}

variable "dns_zone_name" {
  description = "Name of the DNS zone in GCP"
  type        = string
  sensitive   = true
}

variable "aws_access_key" {
  description = "AWS Target Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "gcp_key" {
  description = "GCP servcie account"
  type        = string
  sensitive   = true
}

variable "config_context" {
  description = "Kubernetes cluster ID / context e.g. GKE project"
  type        = string
}

variable "gcp_project" {
  description = "The GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "The GCP region"
  type        = string
}

variable "docker_repo_creds" {
  description = "docker_repo_creds"
  type        = string
  sensitive = true
}


# variable "k8s_cluster_name" {
#   description = "The GCP region"
#   type        = string
# }