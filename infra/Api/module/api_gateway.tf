resource "aws_api_gateway_rest_api" "aws_journey_api" {
  name        = "JourneyAPI"
  description = "AWS Journey API"
  body        = data.template_file.api_spec.rendered

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

data "template_file" "api_spec" {
  template = file("${path.module}/api.yaml")

  vars = {
    run_deployer_name = local.run_deployer_lambda_name
    account_id        = local.account_id
    aws_region        = local.region
  }
}

resource "aws_api_gateway_deployment" "aws_journey_deployment" {
  rest_api_id = aws_api_gateway_rest_api.aws_journey_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.aws_journey_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "journey_portal_stage" {
  deployment_id = aws_api_gateway_deployment.aws_journey_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.aws_journey_api.id
  stage_name    = var.env
}
