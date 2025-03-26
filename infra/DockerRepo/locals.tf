locals {
  account_id         = data.aws_caller_identity.current.account_id
  deployer_role_arn  = data.terraform_remote_state.initializer.outputs.deployer_role_arn
  webapp_role_arn  = data.terraform_remote_state.initializer.outputs.webapp_role_arn
  deployer_repo_name = "Deployer"
  webapp_repo_name   = "Webapp"
  deployer_ecr_assume_roles = [
    local.deployer_role_arn
  ]
  webapp_ecr_assume_roles = [
    local.webapp_role_arn
  ]
}
