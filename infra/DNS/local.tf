locals {
  domain    = data.aws_ssm_parameter.domain_name.value
  zone_id   = aws_route53_zone.hosted_zone.zone_id
  subdomain = "*.${local.domain}"
}
