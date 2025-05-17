resource "aws_ecs_service" "app" {
  name            = local.app_name_lower
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 0
  launch_type     = "FARGATE"
  availability_zone_rebalancing = "ENABLED"

  network_configuration {
    subnets         = var.subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.tester_worker.id]
  }

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"
}
