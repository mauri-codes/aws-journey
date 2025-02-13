module "deployer" {
  source        = "./module"
  build_timeout = 5
  repo          = var.repo
  state_bucket  = data.aws_ssm_parameter.state_bucket_name.value
  state_table   = data.terraform_remote_state.user_state.outputs.table_name
}
