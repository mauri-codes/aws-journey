locals {
  region                   = data.aws_region.current.name
  account_id               = data.aws_caller_identity.current.account_id
  run_deployer_lambda_name = "RunDeployer"
  run_deployer_policy_name = "${local.run_deployer_lambda_name}Policy"
  run_deployer_lambda_arn  = "arn:aws:iam::${local.account_id}:policy/${local.run_deployer_policy_name}"
  lambdas_description = {
    (local.run_deployer_lambda_name) = {
      handler = "bootstrap"
      s3_key  = "lambda/api/${local.run_deployer_lambda_name}.zip"
      environment_variables = {
        STEP_FUNCTIONS = var.step_functions_arn
      }
      policies = [
        local.run_deployer_lambda_arn
      ]
      invoke_from = "api_gateway"
    }
  }
}
