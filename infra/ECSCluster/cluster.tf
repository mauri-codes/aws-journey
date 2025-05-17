resource "aws_ecs_cluster" "cluster" {
  name = local.app_name
}
