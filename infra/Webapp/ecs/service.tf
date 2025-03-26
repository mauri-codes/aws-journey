resource "aws_ecs_service" "webapp" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.webapp.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  availability_zone_rebalancing = "ENABLED"

  load_balancer {
    target_group_arn = aws_lb_target_group.webapp.arn
    container_name   = var.app_name
    container_port   = 3000
  }
  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = true
  }

}