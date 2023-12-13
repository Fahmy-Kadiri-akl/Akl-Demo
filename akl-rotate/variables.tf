variable "domain_suffix" {
  description = "The domain suffix for the Akeyless API Gateway"
  type        = string
  sensitive = true
}

variable "admin_email" {
  description = "Admin email for CLI configuration"
  type        = string
}

variable "admin_password" {
  description = "Admin password"
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