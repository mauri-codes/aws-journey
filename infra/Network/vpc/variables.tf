variable "ip_range_prefix" {
    type = string
    default = "10.16"
}
variable "app_prefix" {
    type = string
}

variable "region" {
    type = string
}

variable "db_table_arn" {
  type = string
}