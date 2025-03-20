data "aws_acm_certificate" "wildcard-certificate" {
  domain = "*.${local.domain}"
}
data "aws_ses_domain_identity" "domain_identity" {
  domain = local.domain
}

data "aws_ssm_parameter" "domain_name" {
  name = "/Domain/Name"
}

data "aws_ssm_parameter" "state_bucket_name" {
  name = "/Infra/State/Bucket/Name"
}

data "terraform_remote_state" "user_state" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/DNS.tfstate"
    region = "us-east-1"
  }
}
