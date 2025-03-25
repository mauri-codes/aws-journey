output "vpc_id" {
    value = aws_vpc.main_vpc.id
}

output "vpc_arn" {
    value = aws_vpc.main_vpc.arn
}

output "igw_arn" {
    value = aws_internet_gateway.igw.arn
}

output "web_A_id" {
  value = aws_subnet.subnets["sn-web-A"].id
}
output "web_B_id" {
  value = aws_subnet.subnets["sn-web-B"].id
}
output "web_C_id" {
  value = aws_subnet.subnets["sn-web-C"].id
}

output "app_A_id" {
  value = aws_subnet.subnets["sn-app-A"].id
}
output "app_B_id" {
  value = aws_subnet.subnets["sn-app-B"].id
}
output "app_C_id" {
  value = aws_subnet.subnets["sn-app-C"].id
}
