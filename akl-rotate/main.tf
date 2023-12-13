terraform {
  required_providers {
  akeyless = {
      version = ">= 1.3.6"
      source  = "akeyless-community/akeyless"
    }
  }
}

#  exprt the UID access_id and token
#  export TF_VAR_uid_access_id=$(terraform output -state=../akl-demo/terraform.tfstate uid_access_id)
#  export TF_VAR_uid_token=$(terraform output -state=../akl-demo/terraform.tfstate uid_token)
#
#
provider "akeyless" {
  api_gateway_address = "https://api.${var.domain_suffix}"

  uid_login {
    access_id   = var.uid_access_id
    uid_token = var.uid_token
  }
}

data "terraform_remote_state" "stage1" {
  backend = "local"
  config = {
    path = "../akl-demo/terraform.tfstate"
  }
}

resource "akeyless_rotated_secret" "postgresql_rotate" {
  name               = "/Demo/0 - Databases/postgresql_rotate"
  target_name        = data.terraform_remote_state.stage1.outputs.postgresql_target_name
  rotator_type       = "target"
  rotation_interval  = "1"
}

resource "akeyless_producer_postgres" "postgresql_producer_ro" {
    name = "/Demo/0 - Databases/postgresql_producer"
    target_name = "${data.terraform_remote_state.stage1.outputs.postgresql_target.name}"

    creation_statements = <<-EOF
    CREATE USER "{{name}}" WITH PASSWORD '{{password}}' ; 
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{name}}";
    GRANT CONNECT ON DATABASE postgres TO "{{name}}";
    GRANT USAGE ON SCHEMA public TO "{{name}}";
    EOF

    # description = <<-EOF
    # Revocation Statement:
    # REASSIGN OWNED BY "{{name}}" TO {{userHost}}; DROP OWNED BY "{{name}}";
    # select pg_terminate_backend(pid) from pg_stat_activity where usename = '{{name}}'; DROP USER "{{name}}";
    # EOF
}