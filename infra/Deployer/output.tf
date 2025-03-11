output "codebuild_project_role_arn" {
  value = module.codebuild_project.codebuild_role_arn
}

output "codebuild_project_role_name" {
  value = module.codebuild_project.codebuild_role_name
}

output "step_functions_arn" {
  value = module.step_function.state_machine_arn
}
