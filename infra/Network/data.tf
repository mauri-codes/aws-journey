data "aws_region" "current" {}

data "aws_ssm_parameter" "state_bucket_name" {
  name = "/Infra/State/Bucket/Name"
}

data "terraform_remote_state" "app_db" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/AppDB.tfstate"
    region = "us-east-1"
  }
}
