resource "akeyless_auth_method_saml" "saml_auth" {
  name              = "/Demo/1 - User/SAML/Okta_user"
  #idp_metadata_url  = var.idp_metadata_url
  idp_metadata_xml_data = var.idp_metadata_xml_data
  unique_identifier = "email"
  force_sub_claims = "true" 
  # ... other necessary configurations ...
}
  #idp_metadata_url  = var.idp_metadata_url
resource "akeyless_associate_role_auth_method" asoc_role_am {
  am_name = akeyless_auth_method_saml.saml_auth.name
  role_name = "/admin"
  sub_claims = {
    groups = var.akeyless_admins_group_name
  }
    lifecycle {
    ignore_changes = [role_name, am_name]
  }
}

resource "akeyless_auth_method_api_key" "api_auth" {
    name = "/Demo/0 - Akeyless/API_Key"
    
}

resource "akeyless_associate_role_auth_method" asoc_role_API_Key {
  am_name = akeyless_auth_method_api_key.api_auth.name
  role_name = "/admin"
    lifecycle {
    ignore_changes = [role_name, am_name]
  }
}

resource "akeyless_auth_method_gcp" "gcp_auth" {
    name = "/Demo/3 - Cloud/GCP_GCE"
    type = "gce"
    audience = "akeyless.io"
    bound_projects = [var.gcp_project]
}

resource "akeyless_associate_role_auth_method" asoc_role_GCP_GE {
  am_name = akeyless_auth_method_gcp.gcp_auth.name
  role_name = "/admin"
    lifecycle {
    ignore_changes = [role_name, am_name]
  }
  }

  resource "akeyless_auth_method_k8s" "k8s_auth"{
    name = "/Demo/2 - Application/K8s_auth"
  }

resource "akeyless_role" "k8s_role" {
  depends_on = [
    akeyless_auth_method_k8s.k8s_auth
  ]
  name = "k8s"

  assoc_auth_method {
    am_name = akeyless_auth_method_k8s.k8s_auth.name
    sub_claims = {
      "namespace" = "my-apps"
    }
  }
  rules {
    capability = ["read","list"]
    path = "/K8s"
    rule_type = "item-rule"
  }
}