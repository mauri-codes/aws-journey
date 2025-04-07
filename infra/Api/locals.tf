locals {
  lambda_logs_policy_arn = data.terraform_remote_state.shared.outputs.lambda_logs_policy_arn
  step_functions_arn     = data.terraform_remote_state.deployer.outputs.step_functions_arn
  user_pool_arn          = data.terraform_remote_state.authentication.outputs.user_pool_arn
  table_arn              = data.terraform_remote_state.db.outputs.table_arn
  infra_bucket           = data.aws_ssm_parameter.state_bucket_name.value
  dyamo_table            = data.aws_ssm_parameter.app_name.value
}
