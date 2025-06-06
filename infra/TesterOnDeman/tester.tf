module "ecs" {
  source                   = "./ecs"
  app_name                 = local.app_name
  region                   = local.region
  cluster_id               = local.cluster_id
  cluster_name             = local.cluster_name
  subnets                  = local.sn_web
  table_arn                = local.table_arn
  tester_repo_url          = local.tester_repo_url
  task_execution_role_arn  = local.task_execution_role_arn
  task_execution_role_name = local.task_execution_role_name
  table_name               = local.app_table
  queue_arn                = local.queue_arn
  worker_max_concurrency   = local.worker_max_concurrency
  worker_timeout           = local.worker_timeout_min
  queue_url                = local.queue_url
  vpc_id                   = local.vpc_id
}

module "step_function" {
  source             = "./state_machine"
  account_id         = local.account_id
  region             = local.region
  state_machine_name = local.state_machine_name
  table_name         = local.app_table
  cluster_name       = local.cluster_name
  service_name       = module.ecs.service_name
  timeout_seconds    = local.worker_timeout_min * 60
  queue_url          = local.queue_url
  queue_arn          = local.queue_arn
  service_arn        = module.ecs.service_arn
}

resource "aws_ssm_parameter" "sqs_arn" {
  name  = "/Infra/Tester/Sqs/QueueArn"
  type  = "String"
  value = aws_sqs_queue.tester_queue.arn
}

resource "aws_ssm_parameter" "worker_timeout" {
  name  = "/Infra/Tester/Ecs/Worker/TimeoutMin"
  type  = "String"
  value = aws_sqs_queue.tester_queue.arn
}

resource "aws_ssm_parameter" "worker_max_concurrency" {
  name  = "/Infra/Tester/Ecs/Worker/MaxConcurrency"
  type  = "String"
  value = aws_sqs_queue.tester_queue.arn
}

resource "aws_ssm_parameter" "ecs_service_name" {
  name  = "/Infra/Tester/Ecs/ServiceName"
  type  = "String"
  value = module.ecs.service_name
}

resource "aws_ssm_parameter" "state_machine_arn" {
  name  = "/Infra/Tester/StepFunctions/Arn"
  type  = "String"
  value = module.step_function.state_machine_arn
}
