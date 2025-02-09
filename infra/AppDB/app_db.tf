module "app_db" {
  source         = "./module"
  table_name     = local.app_name
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
}