output "repo_domain" {
  value = local.repo_domain
}

output "repo_url" {
  value = module.repo.repo_url
}

output "codebuild_role_name" {
  value = local.codebuild_role_name
}

output "repo_arn" {
  value = module.repo.repo_arn
}
