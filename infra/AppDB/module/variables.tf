variable "read_capacity" {
  description = "Read Capacity Units"
  type        = number
}

variable "write_capacity" {
  description = "Write Capacity Units"
  type        = number
}

variable "table_name" {
  type = string
}
