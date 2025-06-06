variable "step" {
  type    = string
  default = "BASE"
}

variable "suffix" {
  type = string
  default = ""
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
