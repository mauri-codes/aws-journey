
module "lambda_role" {
  for_each  = var.lambdas_description
  source    = "../assume_role"
  role_name = "${each.key}Role"
  service   = "lambda"
  managed_policy_arns = concat([
    var.lambda_logs_policy_arn
  ], try(each.value.policies, []))
}

data "aws_s3_object" "deploy_object" {
  for_each          = var.lambdas_description
  bucket = var.infra_bucket
  key    = each.value.s3_key
}

resource "aws_lambda_permission" "apigw" {
  for_each      = local.api_gateway_lambdas
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[each.key].function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${each.value.api_gateway_execution_arn}/*/*"
  # source_arn = "${aws_api_gateway_rest_api.aws_journey_api.execution_arn}/*/*"
}

resource "aws_lambda_function" "lambda" {
  for_each          = var.lambdas_description
  s3_bucket         = var.infra_bucket
  s3_key            = each.value.s3_key
  function_name     = each.key
  role              = module.lambda_role[each.key].role_arn
  handler           = "bootstrap"
  s3_object_version = data.aws_s3_object.deploy_object[each.key].version_id
  runtime           = "provided.al2023"


  environment {
    variables = each.value.environment_variables
  }
}
