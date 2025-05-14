locals {
  region             = data.aws_region.current.name
  account_id         = data.aws_caller_identity.current.account_id
  app_table          = data.terraform_remote_state.app_db.outputs.table_name
  state_machine_name = "Tester"
}
