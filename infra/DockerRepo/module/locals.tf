locals {
  repo_url    = aws_ecr_repository.deployer.repository_url
  repo_domain = split("/", local.repo_url)[0]
}
