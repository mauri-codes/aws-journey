module "user_state" {
  source         = "./module"
  table_name     = local.table_name
  read_capacity  = 5
  write_capacity = 5
}
