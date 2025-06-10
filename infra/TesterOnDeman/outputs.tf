output "state_machine_arn" {
  value = module.step_function.state_machine_arn
}

output "state_machine_parameter_arn" {
  value = aws_ssm_parameter.state_machine_arn.arn
}
