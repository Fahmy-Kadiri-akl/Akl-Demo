
data "external" "startup_script" {
  program = ["bash", "${path.module}/scripts/startup.sh"]
}

#
# UID token only lasts 15 minutes, you can modify the TTL in your UID script
# to keep it longer.
# If the Token expired you can generate a new token using this CLI command 
# akeyless uid-generate-token --auth-method-name "/Demo/0 - Akeyless/UID_Auth" --profile email
# export the new token as an environment variable before running terraform again
# export TF_VAR_uid_access_id="your uid access"  <-- can get it from uid_auth.txt
# export TF_VAR_uid_token="your_new_token_here"

data "external" "script_output" {
  program = ["bash", "${path.module}/scripts/uid_auth.sh"]

  query = {
    ADMIN_EMAIL    = var.admin_email
    ADMIN_PASSWORD = var.admin_password
    # Adding a dummy variable to create a dependency on startup_script
    startup_script_output = data.external.startup_script.result["dummy_output"]
  }
}

# resource "null_resource" "cleanup_before_destroy" {
#   # Triggers the script before this resource is destroyed
#   provisioner "local-exec" {
#     when    = destroy
#     command = "/scripts/cleanup.sh"]"
#   }
#}

module "okta_module" {
  source = "./modules/okta_module"

  okta_org_name  = var.okta_org_name
  okta_base_url  = var.okta_base_url
  okta_api_token = var.okta_api_token
  admin_email    = var.admin_email
}

module "akeyless_module" {
  source                     = "./modules/akeyless_module"
  idp_metadata_xml_data      = module.okta_module.metadata_from_okta_module
  akeyless_admins_group_name = module.okta_module.akeyless_admins_group_name_from_okta_module
  config_context             = var.config_context
  domain_suffix              = var.domain_suffix
  admin_email                = var.admin_email
  uid_access_id              = data.external.script_output.result["uid_access_id"]
  uid_token                  = data.external.script_output.result["uid_token"]
  script_output_t_token      = data.external.script_output.result["t_token"]
  aws_access_key             = var.aws_access_key
  aws_secret_key             = var.aws_secret_key
  gcp_key                    = var.gcp_key
  gcp_region                 = var.gcp_region
  gcp_project                = var.gcp_project
  dns_zone_name              = var.dns_zone_name
  docker_repo_creds         = var.docker_repo_creds
}

