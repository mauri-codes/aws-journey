resource "aws_acm_certificate_validation" "validation" {
  depends_on              = [aws_route53_record.record]
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
}
