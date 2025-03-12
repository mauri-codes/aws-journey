data "aws_ssm_parameter" "state_bucket_name" {
  name = "/Infra/State/Bucket/Name"
}

