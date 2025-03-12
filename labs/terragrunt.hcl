
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "${get_env("USER_STATE_BUCKET")}"
    key            = "users_state/${get_env("USER_ID")}/${get_env("LAB_ID")}/${get_env("RUN_ID")}.tfstate"
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
  region = "${get_env("REGION_A")}"
  assume_role {
    role_arn = "${get_env("ACCOUNT_A_ROLE")}"
  }
}
provider "aws" {
  alias = "account1_B"
  region = "${get_env("REGION_B")}"
  assume_role {
    role_arn = "${get_env("ACCOUNT_A_ROLE")}"
  }
}
provider "aws" {
  alias = "account2_A"
  region = "${get_env("REGION_A")}"
  assume_role {
    role_arn = "${get_env("ACCOUNT_B_ROLE")}"
  }
}
provider "aws" {
  alias = "account2_B"
  region = "${get_env("REGION_B")}"
  assume_role {
    role_arn = "${get_env("ACCOUNT_B_ROLE")}"
  }
}
EOF
}

generate "globals" {
  path = "globals.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
locals {
  account_A_id = "${split(":", get_env("ACCOUNT_A_ROLE"))[4]}"
  account_B_id = "${split(":", get_env("ACCOUNT_B_ROLE"))[4]}"
  region_A = "${get_env("REGION_A")}"
  region_B = "${get_env("REGION_B")}"
}
EOF
}
