resource "aws_ecs_task_definition" "webapp" {
  family = var.app_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = module.task_role.role_arn
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = var.app_name
      image     = var.webapp_repo_url
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}
