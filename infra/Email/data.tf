data "aws_region" "current" {}

data "aws_route53_zone" "hosted_zone" {
  name         = data.aws_ssm_parameter.domain_name.value
  private_zone = false
}

data "aws_ssm_parameter" "domain_name" {
  name = "/Domain/Name"
}
