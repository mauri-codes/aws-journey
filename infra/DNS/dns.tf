# terragrunt apply -target="aws_acm_certificate.domain_cert" -target="aws_acm_certificate.subdomain_cert" -target="aws_route53_zone.hosted_zone"
# terragrunt apply

resource "aws_route53_zone" "hosted_zone" {
  name = local.domain
}

resource "aws_acm_certificate" "domain_cert" {
  domain_name       = local.domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "subdomain_cert" {
  domain_name       = local.subdomain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

module "domain_certificate" {
  source              = "./certificate"
  certificate_arn     = aws_acm_certificate.subdomain_cert.arn
  certificate_options = aws_acm_certificate.subdomain_cert.domain_validation_options
  zone_id             = local.zone_id
}

module "subdomain_certificate" {
  source              = "./certificate"
  certificate_arn     = aws_acm_certificate.domain_cert.arn
  certificate_options = aws_acm_certificate.domain_cert.domain_validation_options
  zone_id             = local.zone_id
}
