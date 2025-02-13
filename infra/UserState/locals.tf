locals {
  app_name   = data.aws_ssm_parameter.app_name.value
  table_name = "${local.app_name}-user-state"
}