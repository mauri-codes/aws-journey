locals {
  app_name = data.aws_ssm_parameter.app_name.value
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_id
  sn_web_A = data.terraform_remote_state.network.outputs.web_A
  sn_web_B = data.terraform_remote_state.network.outputs.web_B
  sn_web_C = data.terraform_remote_state.network.outputs.web_C
  sn_web = [
    local.sn_web_A,
    local.sn_web_B,
    local.sn_web_C
  ]
}
