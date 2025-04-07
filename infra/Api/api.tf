
module "api" {
  source                 = "./module"
  lambda_logs_policy_arn = local.lambda_logs_policy_arn
  step_functions_arn     = local.step_functions_arn
  env                    = "PROD"
  infra_bucket           = local.infra_bucket
  app_table              = local.dyamo_table
  user_pool_arn          = local.user_pool_arn
  table_arn              = local.table_arn
  domain_name            = local.domain_name
  acm_certificate        = local.subdomain_cert_arn
  zone_id                = local.zone_id
}
