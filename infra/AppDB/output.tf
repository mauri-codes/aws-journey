output "table_name" {
  value     = module.app_db.table_name
  sensitive = true
}

output "table_arn" {
  value     = module.app_db.table_arn
  sensitive = true
}

output "read_policy_arn" {
  value = module.policies.read_policy_arn
}

output "modify_policy_arn" {
  value = module.policies.modify_policy_arn
}

output "read_delete_arn" {
  value = module.policies.delete_policy_arn
}
