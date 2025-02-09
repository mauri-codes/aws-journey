locals {
  state_bucket     = data.aws_ssm_parameter.state_bucket_name.value
  user_state_table = data.terraform_remote_state.user_state.outputs.table_name
  app_table        = data.terraform_remote_state.app_db.outputs.table_name
  state_table      = "${data.aws_ssm_parameter.app_name.value}-state"
}
