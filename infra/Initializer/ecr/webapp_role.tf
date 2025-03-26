module "webapp_role" {
  source    = "../../z_common/assume_role"
  service   = "ecs-tasks"
  role_name = var.webapp_role_name
}
