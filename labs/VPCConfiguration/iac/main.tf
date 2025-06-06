resource "aws_vpc" "vpc" {
  cidr_block = local.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.VpcName}${var.suffix}"
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
    "${local.subnet_prefix}web-A" = local.subnet_definition["${local.subnet_prefix}web-A"]
    "${local.subnet_prefix}web-B" = local.subnet_definition["${local.subnet_prefix}web-B"]
    "${local.subnet_prefix}web-C" = local.subnet_definition["${local.subnet_prefix}web-C"]
  }
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_association" {
  for_each = {
    "${local.subnet_prefix}app-A" = local.subnet_definition["${local.subnet_prefix}app-A"]
    "${local.subnet_prefix}app-B" = local.subnet_definition["${local.subnet_prefix}app-B"]
    "${local.subnet_prefix}app-C" = local.subnet_definition["${local.subnet_prefix}app-C"]
    "${local.subnet_prefix}db-A"  = local.subnet_definition["${local.subnet_prefix}db-A"]
    "${local.subnet_prefix}db-B"  = local.subnet_definition["${local.subnet_prefix}db-B"]
    "${local.subnet_prefix}db-C"  = local.subnet_definition["${local.subnet_prefix}db-C"]
  }
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.private_rt.id
}
