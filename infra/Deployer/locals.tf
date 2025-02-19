locals {
  region             = data.aws_region.current.name
  account_id         = data.aws_caller_identity.current.account_id
  state_bucket       = data.aws_ssm_parameter.state_bucket_name.value
  user_state_table   = data.terraform_remote_state.user_state.outputs.table_name
  app_table          = data.terraform_remote_state.app_db.outputs.table_name
  state_table        = "${data.aws_ssm_parameter.app_name.value}-state"
  codebuild_repo     = "${data.aws_ssm_parameter.repo_url.value}:latest"
  codebuild_role     = data.terraform_remote_state.docker_repo.outputs.codebuild_role_name
  ecr_repo_arn       = data.terraform_remote_state.docker_repo.outputs.repo_arn
  state_machine_name = "Deployer"
}
