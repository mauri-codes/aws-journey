data "aws_ssm_parameter" "state_bucket_name" {
  name = "/Infra/State/Bucket/Name"
}

data "aws_ssm_parameter" "app_name" {
  name = "/Infra/App/Name"
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/Shared.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "deployer" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/Deployer.tfstate"
    region = "us-east-1"
  }
}
