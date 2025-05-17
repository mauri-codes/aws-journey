locals {
  app_name                 = "Tester"
  worker_timeout_min       = 5
  worker_max_concurrency   = 5
  region                   = data.aws_region.current.name
  account_id               = data.aws_caller_identity.current.account_id
  app_table                = data.terraform_remote_state.app_db.outputs.table_name
  state_machine_name       = "Tester"
  queue_url                = aws_sqs_queue.tester_queue.url
  queue_arn                = aws_sqs_queue.tester_queue.arn
  vpc_id                   = data.terraform_remote_state.network.outputs.vpc_id
  table_arn                = data.terraform_remote_state.app_db.outputs.table_arn
  task_execution_role_name = data.terraform_remote_state.initializer.outputs.tester_role_name
  task_execution_role_arn  = data.terraform_remote_state.initializer.outputs.tester_role_arn
  cluster_id               = data.terraform_remote_state.ecs_cluster.outputs.cluster_id
  cluster_name             = data.terraform_remote_state.ecs_cluster.outputs.cluster_name
  tester_repo_url          = "${data.terraform_remote_state.docker_repo.outputs.tester_repo_url}:latest"
  sn_web_A                 = data.terraform_remote_state.network.outputs.web_A
  sn_web_B                 = data.terraform_remote_state.network.outputs.web_B
  sn_web_C                 = data.terraform_remote_state.network.outputs.web_C
  sn_web = [
    local.sn_web_A,
    local.sn_web_B,
    local.sn_web_C
  ]
}
