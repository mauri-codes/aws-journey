module "repo" {
  source              = "./module"
  deployer_name       = "lab-deployer"
  codebuild_role_name = local.codebuild_role_name
}

resource "aws_ssm_parameter" "repo_url" {
  name  = "/Infra/Ecr/RepoUrl"
  type  = "String"
  value = module.repo.repo_url
}

resource "aws_ssm_parameter" "repo_domain" {
  name  = "/Infra/Ecr/RepoDomain"
  type  = "String"
  value = local.repo_domain
}
