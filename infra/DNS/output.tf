output "zone_id" {
  value = aws_route53_zone.hosted_zone.zone_id
}
output "domain_certificate_arn" {
  value = aws_acm_certificate.domain_cert.arn
}
output "subdomain_certificate_arn" {
  value = aws_acm_certificate.subdomain_cert.arn
}