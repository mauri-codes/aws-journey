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
