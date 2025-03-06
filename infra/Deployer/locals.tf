locals {
  region                       = data.aws_region.current.name
  account_id                   = data.aws_caller_identity.current.account_id
  state_bucket                 = data.aws_ssm_parameter.state_bucket_name.value
  user_state_table             = data.terraform_remote_state.user_state.outputs.table_name
  lambda_logs_policy_arn       = data.terraform_remote_state.shared.outputs.lambda_logs_policy_arn
  app_table                    = data.terraform_remote_state.app_db.outputs.table_name
  modify_app_table_policy_arn  = data.terraform_remote_state.app_db.outputs.modify_policy_arn
  state_table                  = "${data.aws_ssm_parameter.app_name.value}-state"
  codebuild_repo               = "${data.aws_ssm_parameter.repo_url.value}:latest"
  codebuild_role               = data.terraform_remote_state.docker_repo.outputs.codebuild_role_name
  ecr_repo_arn                 = data.terraform_remote_state.docker_repo.outputs.repo_arn
  get_logs_policy_name         = "Get${local.codebuild_project_name}CloudWatchLogs"
  get_logs_policy_arn          = "arn:aws:iam::${local.account_id}:policy/${local.get_logs_policy_name}"
  state_machine_name           = "Deployer"
  codebuild_project_name       = "LabDeployer"
  start_deployment_lambda_name = "StartDeployment"
  close_deployment_lambda_name = "CloseDeployment"
  deployment_error_lambda_name = "HandleDeploymentError"
  lambdas_description = {
    (local.start_deployment_lambda_name) = {
      handler = "bootstrap"
      s3_key  = "lambda/deployer/${local.start_deployment_lambda_name}.zip"
      environment_variables = {
        APP_TABLE = local.app_table
      }
      policies = [
        local.modify_app_table_policy_arn
      ]
      invoke_from = "step_functions"
    }
    (local.close_deployment_lambda_name) = {
      handler = "bootstrap"
      s3_key  = "lambda/deployer/${local.close_deployment_lambda_name}.zip"
      environment_variables = {
        APP_TABLE = local.app_table
      }
      policies = [
        local.modify_app_table_policy_arn
      ]
      invoke_from = "step_functions"
    }
    (local.deployment_error_lambda_name) = {
      handler = "bootstrap"
      s3_key  = "lambda/deployer/${local.deployment_error_lambda_name}.zip"
      environment_variables = {
        APP_TABLE = local.app_table
      }
      policies = [
        local.modify_app_table_policy_arn,
        local.get_logs_policy_arn
      ]
      invoke_from = "step_functions"
    }
  }
}
