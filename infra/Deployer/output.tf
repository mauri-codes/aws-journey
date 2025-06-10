output "codebuild_project_role_arn" {
  value = local.codebuild_role_arn
}

output "codebuild_project_role_name" {
  value = local.codebuild_role_name
}

output "step_functions_arn" {
  value = module.step_function.state_machine_arn
}

output "step_functions_parameter_arn" {
  value = aws_ssm_parameter.state_machine_arn.arn
}
