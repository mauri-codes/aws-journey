variable "bucket_name" {
  type = string
}

variable "table_name" {
  type = string
}

variable "read_capacity" {
  type = string
}

variable "write_capacity" {
  type = string
}

variable "bucket_force_destroy" {
  default = true
  type    = bool
}
