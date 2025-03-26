output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}
output "lb_id" {
  value = aws_lb.lb.id
}
output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}
output "lb_sg_id" {
  value = aws_security_group.lb.id
}
output "lb_zone_id" {
  value = aws_lb.lb.zone_id
}
