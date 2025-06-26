resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.vpc_name}${var.suffix}"
  }
}

resource "aws_subnet" "subnets" {
  for_each          = local.subnet_definition
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = "${each.key}${var.suffix}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.ig_name}${var.suffix}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.public_rt_name}${var.suffix}"
  }
}

resource "aws_route" "public_ig" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private_rt_a" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.private_rt_name}A${var.suffix}"
  }
}
resource "aws_route_table" "private_rt_b" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.private_rt_name}B${var.suffix}"
  }
}

resource "aws_route_table" "private_rt_c" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.private_rt_name}C${var.suffix}"
  }
}

resource "aws_route_table_association" "web_rt_association" {
  for_each = {
    "${var.subnet_prefix}web-A" = local.subnet_definition["${var.subnet_prefix}web-A"]
    "${var.subnet_prefix}web-B" = local.subnet_definition["${var.subnet_prefix}web-B"]
    "${var.subnet_prefix}web-C" = local.subnet_definition["${var.subnet_prefix}web-C"]
  }
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_a_association" {
  subnet_id      = aws_subnet.subnets["${var.subnet_prefix}app-A"].id
  route_table_id = aws_route_table.private_rt_a.id
}

resource "aws_route_table_association" "private_rt_b_association" {
  subnet_id      = aws_subnet.subnets["${var.subnet_prefix}app-B"].id
  route_table_id = aws_route_table.private_rt_b.id
}

resource "aws_route_table_association" "private_rt_c_association" {
  subnet_id      = aws_subnet.subnets["${var.subnet_prefix}app-C"].id
  route_table_id = aws_route_table.private_rt_c.id
}
