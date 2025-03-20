locals {
  region = data.aws_region.current.name
  domain  = data.aws_ssm_parameter.domain_name.value
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
}