module "lambda_logs_policy" {
  for_each    = local.api_lambdas
  source      = "../../z_common/lambda_logs_policy"
  lambda_name = each.value.name
}

module "lambda_role" {
  for_each  = local.api_lambdas
  source    = "../../z_common/assume_role"
  role_name = each.value.name
  service   = "lambda"
  managed_policy_arns = concat([
    module.lambda_logs_policy[each.key].policy_arn
  ], try(each.value.policies, []))
}

data "aws_s3_object" "deploy_object" {
  bucket = var.infra_bucket
  key    = "lambda/api.zip"
}

resource "aws_lambda_permission" "apigw" {
  for_each      = local.api_lambdas
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[each.key].function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.aws_journey_api.execution_arn}/*/*"
}

resource "aws_lambda_function" "lambda" {
  for_each          = local.api_lambdas
  s3_bucket         = var.infra_bucket
  s3_key            = "lambda/api.zip"
  function_name     = each.value.name
  role              = module.lambda_role[each.key].role_arn
  handler           = each.value.handler
  s3_object_version = data.aws_s3_object.deploy_object.version_id
  runtime           = "provided.al2023"


  environment {
    variables = {
      DYNAMODB_TABLE = var.app_table
    }
  }
}
