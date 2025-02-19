variable "service" {
  type = string
}

variable "role_name" {
  type = string
}

variable "managed_policy_arns" {
  type    = list(string)
  default = []
}

variable "conditions" {
  type = map(object({
    test = string
    variable = string
    values = list(string)
  }))
  default = {}
}
