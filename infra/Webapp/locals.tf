locals {
  region                        = data.aws_region.current.name
  account_id                    = data.aws_caller_identity.current.account_id
  tester_step_functions_arn     = data.terraform_remote_state.tester.outputs.state_machine_arn
  tester_step_functions_param   = data.terraform_remote_state.tester.outputs.state_machine_parameter_arn
  deployer_step_functions_arn   = data.terraform_remote_state.deployer.outputs.step_functions_arn
  deployer_step_functions_param = data.terraform_remote_state.deployer.outputs.step_functions_parameter_arn
  ecr_repo_arn                  = data.terraform_remote_state.docker_repo.outputs.webapp_repo_arn
  ecs_execution_role_name       = data.terraform_remote_state.initializer.outputs.webapp_role_name
  ecs_execution_role_arn        = data.terraform_remote_state.initializer.outputs.webapp_role_arn
  ecs_task_role_name            = "WebappTaskRole"
  table_arn                     = data.terraform_remote_state.app_db.outputs.table_arn
  app_name                      = data.aws_ssm_parameter.app_name.value
  domain_name                   = data.aws_ssm_parameter.domain_name.value
  cluster_id                    = data.terraform_remote_state.ecs_cluster.outputs.cluster_id
  vpc_id                        = data.terraform_remote_state.network.outputs.vpc_id
  domain_cert_arn               = data.terraform_remote_state.dns.outputs.domain_certificate_arn
  subdomain_cert_arn            = data.terraform_remote_state.dns.outputs.subdomain_certificate_arn
  zone_id                       = data.terraform_remote_state.dns.outputs.zone_id
  webapp_repo_url               = "${data.terraform_remote_state.docker_repo.outputs.webapp_repo_url}:latest"
  sn_web_A                      = data.terraform_remote_state.network.outputs.web_A
  sn_web_B                      = data.terraform_remote_state.network.outputs.web_B
  sn_web_C                      = data.terraform_remote_state.network.outputs.web_C
  sn_web = [
    local.sn_web_A,
    local.sn_web_B,
    local.sn_web_C
  ]
}
