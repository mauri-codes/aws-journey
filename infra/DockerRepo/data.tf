data "aws_ssm_parameter" "app_name" {
  name = "/Infra/App/Name"
}
