output "repo_url" {
  value = aws_ecr_repository.deployer.repository_url
}

output "repo_arn" {
  value = aws_ecr_repository.deployer.arn
}
