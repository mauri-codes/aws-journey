module "base_infrastructure" {
  source         = "../module"
  bucket_name    = local.bucket_name
  read_capacity  = 5
  write_capacity = 5
  table_name     = local.table_name
}

resource "aws_ssm_parameter" "bucket_name" {
  name  = "/Infra/State/Bucket/Name"
  type  = "String"
  value = module.base_infrastructure.bucket_name
}

resource "aws_ssm_parameter" "app_name" {
  name  = "/Infra/App/Name"
  type  = "String"
  value = var.app_name
}

resource "aws_ssm_parameter" "repo_name" {
  name  = "/Infra/Repo/Name"
  type  = "String"
  value = var.repo_name
}
