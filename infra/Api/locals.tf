locals {
  compressed_file = "${path.module}/api.zip"
  built_file      = "${path.module}/lambda/bootstrap"
  app_table       = data.terraform_remote_state.app_db.outputs.table_name
  app_table_arn   = data.terraform_remote_state.app_db.outputs.table_arn
  infra_bucket    = data.aws_ssm_parameter.state_bucket_name.value
}