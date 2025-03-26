resource "aws_route53_record" "root_domain" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "subdomain" {
  zone_id = var.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}

# resource "aws_route53_record" "wildcard_subdomains" {
#   zone_id = aws_route53_zone.example_com.zone_id
#   name    = "*.example.com"
#   type    = "A"

#   alias {
#     name                   = aws_lb.ecs_alb.dns_name
#     zone_id                = aws_lb.ecs_alb.zone_id
#     evaluate_target_health = true
#   }
# }
