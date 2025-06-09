variable "vpc_cidr_block" {
  type = string 
}
variable "subnet_prefix" {
  type = string 
}
variable "suffix" {
  type = string 
}
variable "subnet_definition" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
}
variable "VpcName" {
  type = string 
}
variable "InternetGatewayName" {
  type = string 
}
variable "PublicRouteTableName" {
  type = string 
}
variable "PrivateRouteTableName" {
  type = string 
}