
terraform {
  required_providers {
    okta = {
      source = "okta/okta"
      version = "~> 4.6.3"
    }
  }
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

#create an Okta SAML application in Terraform
resource "okta_app_saml" "Akeyless" {
  label                    = "Akeyless"
  sso_url                         = "https://auth.akeyless.io/saml/acs"
  recipient                       = "https://auth.akeyless.io/saml/acs"
  destination                     = "https://auth.akeyless.io/saml/acs"
  audience                        = "https://auth.akeyless.io/saml/metadata"
  subject_name_id_template = "$${user.userName}"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  response_signed          = true
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  honor_force_authn        = false
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

  attribute_statements {
    name       = "email"
    namespace  = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
    type       = "EXPRESSION"
    values     = ["user.email"]
  }

  attribute_statements {
    name       = "user"
    namespace  = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
    type       = "EXPRESSION"
    values     = ["user.login"]
  }

  attribute_statements {
    type         = "GROUP"
    name         = "groups"
    filter_type  = "REGEX"
    filter_value = ".*"
  }
}

data "okta_user" "admin_email" {
  search {
    name = "profile.email"
    value = var.admin_email
  }
}

resource "okta_group" "Akeyless_admins" {
  name        = "Akeyless_admins"
  description = "Akeyless super admin group"
}
#assign users to Okta SAML Application
resource "okta_group_memberships" Akeyless_admins {
  group_id = okta_group.Akeyless_admins.id
  users = [data.okta_user.admin_email.id]
}

resource "okta_app_group_assignments" "Akeyless_app_assignment" {
  app_id = okta_app_saml.Akeyless.id
  group {
    id = okta_group.Akeyless_admins.id
    priority = 1
  }
}