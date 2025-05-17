resource "aws_security_group" "tester_worker" {
  vpc_id = var.vpc_id
  name = local.tester_worker_sg_name
  tags = {
    Name = local.tester_worker_sg_name
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tester_worker.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
