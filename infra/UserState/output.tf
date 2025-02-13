output "table_arn" {
  value = module.user_state.table_arn
}

output "table_name" {
  value     = module.user_state.table_name
  sensitive = true
}
