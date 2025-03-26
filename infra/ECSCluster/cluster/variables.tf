variable "app_name" {
  type = string
}
variable "lb_subnets" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}