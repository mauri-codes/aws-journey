resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.VpcName}${var.suffix}"
  }
}

resource "aws_subnet" "subnets" {
  for_each          = var.subnet_definition
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
    Name = "${var.InternetGatewayName}${var.suffix}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.PublicRouteTableName}${var.suffix}"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "10.16.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "${var.PrivateRouteTableName}${var.suffix}"
  }
}

resource "aws_route_table_association" "web_rt_association" {
  for_each = {
    "${var.subnet_prefix}web-A" = var.subnet_definition["${var.subnet_prefix}web-A"]
    "${var.subnet_prefix}web-B" = var.subnet_definition["${var.subnet_prefix}web-B"]
    "${var.subnet_prefix}web-C" = var.subnet_definition["${var.subnet_prefix}web-C"]
  }
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_association" {
  for_each = {
    "${var.subnet_prefix}app-A" = var.subnet_definition["${var.subnet_prefix}app-A"]
    "${var.subnet_prefix}app-B" = var.subnet_definition["${var.subnet_prefix}app-B"]
    "${var.subnet_prefix}app-C" = var.subnet_definition["${var.subnet_prefix}app-C"]
    "${var.subnet_prefix}db-A"  = var.subnet_definition["${var.subnet_prefix}db-A"]
    "${var.subnet_prefix}db-B"  = var.subnet_definition["${var.subnet_prefix}db-B"]
    "${var.subnet_prefix}db-C"  = var.subnet_definition["${var.subnet_prefix}db-C"]
  }
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.private_rt.id
}
