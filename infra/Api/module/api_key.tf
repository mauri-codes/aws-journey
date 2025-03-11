resource "aws_api_gateway_api_key" "key" {
  name = "internal_access"
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name         = "journey-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.aws_journey_api.id
    stage  = aws_api_gateway_stage.journey_portal_stage.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  key_id        = aws_api_gateway_api_key.key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}

resource "aws_ssm_parameter" "api_key" {
  name  = "/infra/Api/Key"
  type  = "SecureString"
  value = aws_api_gateway_api_key.key.value
}
