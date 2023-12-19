output "uid_access_id" {
  value = data.external.script_output.result["uid_access_id"]
}

output "uid_token" {
  value = data.external.script_output.result["uid_token"]
}

output "script_output_t_token" {
  value = data.external.script_output.result["t_token"]
}

output "child_module_api_access_id" {
  value     = module.akeyless_module.api_access_id
}

output "child_module_api_access_key" {
  value     = module.akeyless_module.api_access_key
  sensitive = true
}