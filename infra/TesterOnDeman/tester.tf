
module "step_function" {
  source             = "./state_machine"
  account_id         = local.account_id
  region             = local.region
  state_machine_name = local.state_machine_name
  table_name         = local.app_table
}
