module "deployer_role" {
  source    = "../../z_common/assume_role"
  service   = "codebuild"
  role_name = var.deployer_role_name
}
