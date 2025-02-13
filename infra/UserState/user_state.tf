module "user_state" {
  source = "./module"
  table_name = var.table_name
  read_capacity = 5
  write_capacity = 5
}
