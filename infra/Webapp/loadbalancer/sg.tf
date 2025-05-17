resource "aws_security_group" "lb" {
  name        = "jn-lb-sg"
  description = "Allow TLS inbound traffic and all outbound traffic for Load Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name = "jn-lb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_tls_ipv4" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "public_tls_ipv6" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "public_http_tls_ipv4" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "public_http_tls_ipv6" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}
