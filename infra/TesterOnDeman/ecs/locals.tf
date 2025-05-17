locals {
  app_name_lower        = lower(var.app_name)
  app_name              = var.app_name
  tester_worker_sg_name = "tester-worker-sg"
}
