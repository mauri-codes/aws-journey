module "app_db" {
  source         = "./module"
  table_name     = local.app_name
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
}

module "policies" {
  source      = "../z_common/dynamo_policies"
  table_arn   = module.app_db.table_arn
  table_label = local.table_label
}
