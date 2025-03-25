locals {
  region = data.aws_region.current.name
  table_arn = data.terraform_remote_state.app_db.outputs.table_arn
}