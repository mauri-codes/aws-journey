locals {
  domain              = data.aws_ssm_parameter.domain_name.value
  ses_domain_identity = data.aws_ses_domain_identity.domain_identity.arn
  certificate_arn     = data.aws_acm_certificate.wildcard-certificate.arn
  zone_id             = data.terraform_remote_state.user_state.outputs.zone_id
}
