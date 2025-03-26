resource "aws_security_group" "ecs_tasks_sg" {
  vpc_id = var.vpc_id
  name = "ecs-tasks-sg"
  tags = {
    Name = "ecs-tasks-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_http_80" {
  security_group_id = aws_security_group.ecs_tasks_sg.id
  referenced_security_group_id = var.lb_sg_id
  # cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "public_http_3000" {
  security_group_id = aws_security_group.ecs_tasks_sg.id
  referenced_security_group_id = var.lb_sg_id
  # cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ecs_tasks_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
