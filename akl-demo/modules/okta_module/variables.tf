variable "okta_org_name" {
  description = "The Okta organization name"
  type        = string
}

variable "okta_base_url" {
  description = "The Okta base URL"
  type        = string
}

variable "okta_api_token" {
  description = "API Token for Okta"
  type        = string
  sensitive   = true
}

variable "admin_email" {
  description = "Admin email for CLI configuration"
  type        = string
}
