output "deployer_role_name" {
  value = local.deployer_role_name
}
output "deployer_role_arn" {
  value = module.ecr.deployer_role_arn
}
output "webapp_role_name" {
  value = local.webapp_role_name
}
output "webapp_role_arn" {
  value = module.ecr.webapp_role_arn
}
output "tester_role_name" {
  value = local.tester_role_name
}
output "tester_role_arn" {
  value = module.ecr.tester_role_arn
}
