resource "aws_route53_record" "record" {
  zone_id = local.zone_id
  name    = module.user_pool.user_pool_domain
  type    = "A"

  alias {
    name                   = module.user_pool.user_pool_domain_distribution_arn
    zone_id                = "Z2FDTNDATAQYW2" # Fixed Zone Id
    evaluate_target_health = false
  }
}
