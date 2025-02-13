
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "${get_env("USER_STATE_BUCKET")}"
    key            = "users_state/${get_env("USER_ID")}/${get_env("LAB_ID")}/${get_env("RUN_ID")}_${get_env("CURRENT_DATE")}.tfstate"
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
  region = "${get_env("ACCOUNT_1_REGION_A")}"
  assume_role {
    role_arn = "${get_env("ACCOUNT_1_ROLE")}"
  }
}
provider "aws" {
  alias = "account1_B"
  region = "${get_env("ACCOUNT_1_REGION_B")}"
  assume_role {
    role_arn = "${get_env("ACCOUNT_1_ROLE")}"
  }
}
provider "aws" {
  alias = "account2_A"
  region = "${get_env("ACCOUNT_2_REGION_A")}"
  assume_role {
    role_arn = "${get_env("ACCOUNT_2_ROLE")}"
  }
}
provider "aws" {
  alias = "account2_B"
  region = "${get_env("ACCOUNT_2_REGION_B")}"
  assume_role {
    role_arn = "${get_env("ACCOUNT_2_ROLE")}"
  }
}
EOF
}
