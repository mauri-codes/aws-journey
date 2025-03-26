locals {
  repo_url    = aws_ecr_repository.deployer.repository_url
  repo_domain = split("/", local.repo_url)[0]
  repo_name   = lower(var.repo_name)
}
