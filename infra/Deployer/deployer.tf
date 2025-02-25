module "codebuild_project" {
  source              = "./codebuild_project"
  build_timeout       = 5
  repo                = var.repo
  state_bucket        = local.state_bucket
  state_table         = local.state_table
  user_state_table    = local.user_state_table
  app_table           = local.app_table
  codebuild_image     = local.codebuild_repo
  codebuild_role_name = local.codebuild_role
  ecr_repo_arn        = local.ecr_repo_arn
}

module "lambdas" {
  source                 = "../z_common/lambda_collection"
  lambda_logs_policy_arn = local.lambda_logs_policy_arn
  infra_bucket           = local.state_bucket
  lambdas_description    = local.lambdas_description
}

module "step_function" {
  source                      = "./state_machine"
  account_id                  = local.account_id
  region                      = local.region
  codebuild_project_arn       = module.codebuild_project.codebuild_project_arn
  state_machine_name          = local.state_machine_name
  codebuild_project_name      = module.codebuild_project.codebuild_project_name
  start_deployment_lambda_arn = "arn:aws:lambda:${local.region}:${local.account_id}:function:${local.start_deployment_lambda_name}"
  close_deployment_lambda_arn = "arn:aws:lambda:${local.region}:${local.account_id}:function:${local.close_deployment_lambda_name}"
  error_handler_lambda_arn    = "arn:aws:lambda:${local.region}:${local.account_id}:function:${local.deployment_error_lambda_name}"
  depends_on                  = [module.lambdas]
}
