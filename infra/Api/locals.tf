locals {
  lambda_logs_policy_arn = data.terraform_remote_state.shared.outputs.lambda_logs_policy_arn
  step_functions_arn     = data.terraform_remote_state.deployer.outputs.step_functions_arn
  infra_bucket           = data.aws_ssm_parameter.state_bucket_name.value
}
