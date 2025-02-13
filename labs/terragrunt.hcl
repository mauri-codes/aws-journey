
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "${get_env("USER_STATE_BUCKET")}"
    key            = "users_state/${path_relative_to_include()}.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "${get_env("USER_STATE_TABLE")}"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  alias = "account1_A"
  assume_role {
    role_arn = "${get_env("ACCOUNT_1_ROLE")}"
    region = "${get_env("ACCOUNT_1_REGION_A")}"
  }
}
provider "aws" {
  alias = "account1_B"
  assume_role {
    role_arn = "${get_env("ACCOUNT_1_ROLE")}"
    region = "${get_env("ACCOUNT_1_REGION_B")}"
  }
}
provider "aws" {
  alias = "account2_A"
  assume_role {
    role_arn = "${get_env("ACCOUNT_2_ROLE")}"
    region = "${get_env("ACCOUNT_2_REGION_A")}"
  }
}
provider "aws" {
  alias = "account2_B"
  assume_role {
    role_arn = "${get_env("ACCOUNT_2_ROLE")}"
    region = "${get_env("ACCOUNT_2_REGION_B")}"
  }
}
EOF
}
