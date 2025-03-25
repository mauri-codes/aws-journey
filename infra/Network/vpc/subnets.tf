resource "aws_subnet" "subnets" {
  for_each = local.subnets
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "${var.ip_range_prefix}.${each.value.cidr_block_suffix}"
  availability_zone = each.value.az

  tags = {
    Name = "${var.app_prefix}-${each.key}"
  }
}
