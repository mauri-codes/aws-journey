resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.app_prefix}-web-rt"
  }
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "10.16.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "${var.app_prefix}-app-rt"
  }
}

resource "aws_route_table_association" "web_association" {
  for_each = {
    "sn-web-A" = local.subnets.sn-web-A
    "sn-web-B" = local.subnets.sn-web-B
    "sn-web-C" = local.subnets.sn-web-C
  }
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "app_association" {
  for_each = {
    "sn-app-A" = local.subnets.sn-app-A
    "sn-app-B" = local.subnets.sn-app-B
    "sn-app-C" = local.subnets.sn-app-C
  }
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.private_rt.id
}
