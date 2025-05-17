output "deployer_role_arn" {
  value = module.deployer_role.role_arn
}

output "webapp_role_arn" {
  value = module.webapp_role.role_arn
}

output "tester_role_arn" {
  value = module.tester_role.role_arn
}
