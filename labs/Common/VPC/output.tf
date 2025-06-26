output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value = {
    for name, subnet in aws_subnet.subnets :
    name => subnet.id
  }
}