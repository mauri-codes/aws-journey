data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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


data "terraform_remote_state" "app_db" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/AppDB.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/ECSCluster.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "docker_repo" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/DockerRepo.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = data.aws_ssm_parameter.state_bucket_name.value
    key    = "terraform/Network.tfstate"
    region = "us-east-1"
  }
}
