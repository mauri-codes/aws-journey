module "tester_role" {
  source    = "../../z_common/assume_role"
  service   = "ecs-tasks"
  role_name = var.tester_role_name
}
