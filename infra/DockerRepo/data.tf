data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "app_name" {
  name = "/Infra/App/Name"
}

data "aws_ssm_parameter" "state_bucket_name" {
  name = "/Infra/State/Bucket/Name"
}

data "terraform_remote_state" "initializer" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/Initializer.tfstate"
    region = "us-east-1"
  }
}
