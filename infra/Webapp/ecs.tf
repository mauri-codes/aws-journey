module "lb" {
  source     = "./loadbalancer"
  app_name   = local.app_name
  lb_subnets = local.sn_web
  vpc_id     = local.vpc_id
}

module "ecs" {
  source                  = "./ecs"
  ecr_repo_arn            = local.ecr_repo_arn
  ecs_execution_role_name = local.ecs_execution_role_name
  alb_id                  = module.lb.lb_id
  cluster_id              = local.cluster_id
  app_name                = local.app_name
  ecs_task_role_name      = local.ecs_task_role_name
  service_name            = "webapp"
  table_arn               = local.table_arn
  domain_cert_arn         = local.domain_cert_arn
  subdomain_cert_arn      = local.subdomain_cert_arn
  vpc_id                  = local.vpc_id
  webapp_repo_url         = local.webapp_repo_url
  domain_name             = local.domain_name
  subnets                 = local.sn_web
  ecs_execution_role_arn  = local.ecs_execution_role_arn
  lb_sg_id                = module.lb.lb_sg_id
  region                  = local.region
}

resource "aws_route53_record" "root_domain" {
  zone_id = local.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = module.lb.lb_dns_name
    zone_id                = module.lb.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard_subdomains" {
  zone_id = local.zone_id
  name    = "*.${local.domain_name}"
  type    = "A"

  alias {
    name                   = module.lb.lb_dns_name
    zone_id                = module.lb.lb_zone_id
    evaluate_target_health = true
  }
}
