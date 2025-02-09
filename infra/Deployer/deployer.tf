module "deployer" {
  source           = "./module"
  build_timeout    = 5
  repo             = var.repo
  state_bucket     = local.state_bucket
  state_table      = local.state_table
  user_state_table = local.user_state_table
  app_table        = local.app_table
}
