variable "domain_suffix" {
  description = "The domain suffix for the Akeyless API Gateway"
  type        = string
  sensitive = true
}

variable "admin_email" {
  description = "Admin email for CLI configuration"
  type        = string
}

variable "uid_access_id" {
  description = "UID access ID for Akeyless"
  type        = string
}

variable "uid_token" {
  description = "UID token for Akeyless"
  type        = string
  sensitive = true
}

variable "idp_metadata_xml_data" {
  description = "IDP Metadata from SAML Provider"
  type        = string
  sensitive   = true
}

variable "akeyless_admins_group_name" {
  description = "The name of the Akeyless Admins group in Okta"
  type        = string
}

variable "aws_access_key" {
  description = "AWS Target Access Key"
  type = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type = string
  sensitive   = true
}

variable "gcp_key" {
  description = "GCP servcie account"
  type = string
  sensitive   = true
}

variable "config_path" {
  description = "Path to the kube config file"
  type        = string
  default     = "~/.kube/config" 
}

variable "config_context" {
  description = "Kube context from root module, defined in tfvars file"
  type = string
}

variable "namespaces" {
  description = "List of namespaces to create"
  type        = list(string)
  default     = ["akeyless", "cert-manager", "k8sinjector", "my-apps"]
}

variable "hostname" {
  description = "List of hostnames"
  type        = list(string)
  default     = ["conf", "ui", "hvp", "api", "rest", "bast", "ztwa", "ubuntu", "custom"]
}

variable "gcp_project" {
  description = "The GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "The GCP region"
  type        = string
}

variable "dns_zone_name" {
  description = "Name of the DNS zone in GCP"
  type        = string
  sensitive     = true
}

# variable "k8s_cluster_name" {
#   description = "The GCP region"
#   type        = string
# }