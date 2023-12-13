
#capture the Okta metadata_url value from the okta_app_saml resource in /modules/okta_module/main.tf
# output "metadata_url_from_okta_module" {
#   value = okta_app_saml.Akeyless.metadata_url
#   description = "The metadata URL of the Akeyless SAML application in Okta"
# }

output "metadata_from_okta_module"{
  value = okta_app_saml.Akeyless.metadata
  description = "The XML metadata of the Akeyless SAML application in Okta"
}

output "user_id_from_okta_module" {
    value = data.okta_user.admin_email.id
    description = "The root Akeyless user's Okta ID, we will use this to assign the user to a group"
}

output "akeyless_admins_group_name_from_okta_module" {
  value = okta_group.Akeyless_admins.name
  description = "The name of the Akeyless Admins group in Okta"
}