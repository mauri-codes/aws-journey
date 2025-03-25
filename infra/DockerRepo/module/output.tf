output "repo_url" {
  value = local.repo_url
}

output "repo_arn" {
  value = aws_ecr_repository.deployer.arn
}

output "repo_domain" {
  value = local.repo_domain
}
