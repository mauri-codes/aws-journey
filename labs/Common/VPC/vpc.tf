resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
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

  dynamic "route" {
    for_each = var.public_routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
    }
  }

  dynamic "route" {
    for_each = var.public_ig_route ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
  }
  
  route {
    cidr_block = "10.16.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "${var.public_rt_name}${var.suffix}"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = var.private_routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
    }
  }
  route {
    cidr_block = "10.16.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "${var.private_rt_name}${var.suffix}"
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

resource "aws_route_table_association" "private_rt_association" {
  for_each = {
    "${var.subnet_prefix}app-A" = local.subnet_definition["${var.subnet_prefix}app-A"]
    "${var.subnet_prefix}app-B" = local.subnet_definition["${var.subnet_prefix}app-B"]
    "${var.subnet_prefix}app-C" = local.subnet_definition["${var.subnet_prefix}app-C"]
    "${var.subnet_prefix}db-A"  = local.subnet_definition["${var.subnet_prefix}db-A"]
    "${var.subnet_prefix}db-B"  = local.subnet_definition["${var.subnet_prefix}db-B"]
    "${var.subnet_prefix}db-C"  = local.subnet_definition["${var.subnet_prefix}db-C"]
  }
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.private_rt.id
}
