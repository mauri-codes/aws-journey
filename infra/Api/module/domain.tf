resource "aws_api_gateway_domain_name" "domain" {
  domain_name              = local.api_gateway_domain
  regional_certificate_arn = var.acm_certificate

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "mapping" {
  stage_name  = local.stage_name
  api_id      = local.api_gateway_id
  domain_name = aws_api_gateway_domain_name.domain.domain_name
}

resource "aws_route53_record" "api" {
  zone_id = var.zone_id
  name    = local.api_gateway_domain
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.domain.regional_zone_id
    evaluate_target_health = true
  }
}

