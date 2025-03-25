output "deployer_role_name" {
  value = local.deployer_role_name
}
output "deployer_role_arn" {
  value = module.ecr.deployer_role_arn
}
output "webapp_role_name" {
  value = local.webapp_role_name
}
