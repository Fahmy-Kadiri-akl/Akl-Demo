data "google_container_cluster" "my_cluster" {
  name     = "${local.cluster_name}"
  location = "${var.gcp_region}"
}