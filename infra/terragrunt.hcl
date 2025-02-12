
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "${get_env("INFRA_BUCKET_NAME")}"
    key            = "terraform/${path_relative_to_include()}.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "${get_env("INFRA_TABLE_NAME")}"
  }
}
