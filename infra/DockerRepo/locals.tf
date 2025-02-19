locals {
  repo_domain         = split("/", module.repo.repo_url)[0]
  codebuild_role_name = "LabDeployer"
}