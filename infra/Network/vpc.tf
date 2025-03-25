module "network" {
  source          = "./vpc"
  region          = local.region
  app_prefix      = "jn"
  ip_range_prefix = "10.16"
  db_table_arn    = local.table_arn
}
