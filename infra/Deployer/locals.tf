locals {
  state_bucket = data.aws_ssm_parameter.state_bucket_name.value
  state_table  = data.terraform_remote_state.user_state.outputs.table_name
  app_table    = data.terraform_remote_state.app_db.outputs.table_name
}
