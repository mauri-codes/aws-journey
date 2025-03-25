
resource "aws_ssm_parameter" "repo_url" {
  name  = "/Infra/Ecr/${var.repo_name}/Url"
  type  = "String"
  value = local.repo_url
}

resource "aws_ssm_parameter" "repo_domain" {
  name  = "/Infra/Ecr/${var.repo_name}/Domain"
  type  = "String"
  value = local.repo_domain
}
