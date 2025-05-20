resource "aws_ecs_task_definition" "app" {
  family                   = local.app_name_lower
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  execution_role_arn = var.task_execution_role_arn
  task_role_arn      = module.task_role.role_arn

  container_definitions = jsonencode([
    {
      name      = local.app_name_lower
      image     = var.tester_repo_url
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      },
      environment = [
        {
          name = "TABLE_NAME"
          value = var.table_name
        },
        {
          name = "QUEUE_URL"
          value = var.queue_url
        },
        {
          name = "IDLE_TIMEOUT_MIN"
          value = var.worker_timeout
        },
        {
          name = "MAX_CONCURRENCY"
          value = var.worker_max_concurrency
        },
        {
          name = "SERVICE_NAME"
          value = local.app_name_lower
        },
        {
          name = "CLUSTER_NAME"
          value = var.cluster_name
        }
      ]
    }
  ])
}
