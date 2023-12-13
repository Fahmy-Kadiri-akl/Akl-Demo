resource "akeyless_target_aws" "aws_target" {
    name = "/Demo/1 - Cloud/AWS_Target"
    access_key_id = var.aws_access_key
    access_key = var.aws_secret_key
    description = "create an AWS target to manage in Akeyless"
}


resource "akeyless_target_gcp" "gcp_target" {
    name = "/Demo/1 - Cloud/GCP_Target"
    gcp_key = var.gcp_key
    description = "create an AWS target to manage in Akeyless"
}


resource "akeyless_target_db" "postgresql_target" {
    depends_on =[helm_release.install_postgresql]
#    depends_on =[null_resource.install_postgresql]
    db_type = "postgres"
    name = "/Demo/0 - Databases/postgresql"
    db_name = "postgres"
    port = "5432"
    host = "postgresql.my-apps.svc.cluster.local"
    user_name = "postgres"
    pwd = "MyPassword"
}



# resource "akeyless_producer_postgres" "postgresql_producer_su" {
#     depends_on = [akeyless_target_db.postgresql_target]
#     name = "/Demo/0 - Databases/postgresql_producer"
#     target_name = "${akeyless_target_db.postgresql_target.name}"

#     creation_statements = <<-EOF
#     CREATE ROLE "{{name}}" WITH SUPERUSER CREATEDB CREATEROLE LOGIN ENCRYPTED PASSWORD '{{password}}';
#     EOF

#     # description = <<-EOF
#     # Revocation:
#     # REASSIGN OWNED BY "{{name}}" TO {{userHost}};
#     # DROP OWNED BY "{{name}}";
#     # SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE usename = '{{name}}';
#     # DROP USER "{{name}}";
#     # EOF
# }
