variable "lambdas_description" {
  type = map(object({
    s3_key                = string
    policies              = list(string)
    environment_variables = map(string)
    invoke_from           = string
  }))
}

variable "infra_bucket" {
  type = string
}

variable "lambda_logs_policy_arn" {
  type = string
}
