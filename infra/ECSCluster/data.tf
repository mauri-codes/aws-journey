
data "aws_ssm_parameter" "state_bucket_name" {
  name = "/Infra/State/Bucket/Name"
}

data "aws_ssm_parameter" "app_name" {
  name = "/Infra/App/Name"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/Network.tfstate"
    region = "us-east-1"
  }
}
