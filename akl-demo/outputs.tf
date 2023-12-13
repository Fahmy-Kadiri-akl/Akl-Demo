output "uid_access_id" {
  value = data.external.script_output.result["uid_access_id"]
}

output "uid_token" {
  value = data.external.script_output.result["uid_token"]
}