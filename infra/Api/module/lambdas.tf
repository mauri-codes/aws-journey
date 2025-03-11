module "lambdas" {
  source                    = "../../z_common/lambda_collection"
  lambda_logs_policy_arn    = var.lambda_logs_policy_arn
  infra_bucket              = var.infra_bucket
  lambdas_description       = local.lambdas_description
  api_gateway_execution_arn = aws_api_gateway_rest_api.aws_journey_api.execution_arn
  depends_on = [
    aws_iam_policy.run_deployer_policy
  ]
}
