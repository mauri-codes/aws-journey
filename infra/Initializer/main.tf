module "ecr" {
  source             = "./ecr"
  deployer_role_name = local.deployer_role_name
  webapp_role_name   = local.webapp_role_name
  tester_role_name   = local.tester_role_name
}
