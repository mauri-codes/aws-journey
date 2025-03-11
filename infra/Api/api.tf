
module "api" {
  source                 = "./module"
  lambda_logs_policy_arn = local.lambda_logs_policy_arn
  step_functions_arn     = local.step_functions_arn
  env                    = "PROD"
  infra_bucket           = local.infra_bucket
}
