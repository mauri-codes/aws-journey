module "cluster" {
  source     = "./cluster"
  app_name   = local.app_name
  lb_subnets = local.sn_web
  vpc_id     = local.vpc_id
}
