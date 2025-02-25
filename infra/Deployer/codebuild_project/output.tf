output "codebuild_role_arn" {
  value = module.codebuild_role.role_arn
}

output "codebuild_role_name" {
  value = module.codebuild_role.role_name
}

output "codebuild_project_name" {
  value = aws_codebuild_project.project.name
}

output "codebuild_project_arn" {
  value = aws_codebuild_project.project.arn
}
