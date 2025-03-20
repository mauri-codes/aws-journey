
module "user_pool" {
  source              = "./user_pool"
  user_pool_name      = "aws-journey"
  domain              = local.domain
  certificate_arn     = local.certificate_arn
  ses_domain_identity = local.ses_domain_identity
}
