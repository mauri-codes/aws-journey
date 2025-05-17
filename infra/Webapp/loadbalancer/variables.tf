variable "vpc_id" {
  type = string
}
variable "app_name" {
  type = string
}
variable "lb_subnets" {
  type = list(string)
}
