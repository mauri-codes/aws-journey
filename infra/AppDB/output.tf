output "table_name" {
  value     = module.app_db.table_name
  sensitive = true
}