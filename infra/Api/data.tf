data "aws_ssm_parameter" "state_bucket_name" {
  name = "/Infra/State/Bucket/Name"
}

data "aws_ssm_parameter" "app_name" {
  name = "/Infra/App/Name"
}

data "aws_ssm_parameter" "domain_name" {
  name = "/Domain/Name"
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

data "terraform_remote_state" "authentication" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/Authentication.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/AppDB.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "dns" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/DNS.tfstate"
    region = "us-east-1"
  }
}
