module "deployer_repo" {
  source           = "./module"
  repo_name        = "Deployer"
  ecr_assume_roles = local.deployer_ecr_assume_roles
}

module "webapp_repo" {
  source           = "./module"
  repo_name        = "Webapp"
  ecr_assume_roles = local.webapp_ecr_assume_roles
}

module "tester_repo" {
  source           = "./module"
  repo_name        = "Tester"
  ecr_assume_roles = local.tester_ecr_assume_roles
}

module "tester_ecr_policy" {
  source = "../z_common/task_execution_ecr"
  ecr_repo_arn = module.tester_repo.repo_arn
  policy_name = "TesterEcrAccess"
  role_name = "TesterTaskExecutionRole"
}
