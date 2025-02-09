resource "aws_ecr_repository" "repo" {
  name                 = data.aws_ssm_parameter.app_name.value
  image_tag_mutability = "MUTABLE"
}

resource "aws_ssm_parameter" "app_name" {
  name  = "/Infra/Ecr/RepoUrl"
  type  = "String"
  value = aws_ecr_repository.repo.repository_url
}
