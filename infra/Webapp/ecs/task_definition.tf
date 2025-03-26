resource "aws_ecs_task_definition" "webapp" {
  family                   = var.app_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = module.task_role.role_arn
  cpu                      = 1024
  memory                   = 2048
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
  container_definitions = jsonencode([
    {
      name      = var.app_name
      image     = var.webapp_repo_url
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          name          = "port-3000"
          appProtocol   = "http"
        }
      ]
    }
  ])
}
