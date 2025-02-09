output "table_name" {
  value     = module.app_db.table_name
  sensitive = true
}

output "table_arn" {
  value     = module.app_db.table_arn
  sensitive = true
}
