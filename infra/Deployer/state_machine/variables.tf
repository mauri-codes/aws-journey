variable "start_deployment_lambda_arn" {
  type = string
}

variable "close_deployment_lambda_arn" {
  type = string
}

variable "error_handler_lambda_arn" {
  type = string
}

variable "codebuild_project_arn" {
  type = string
}

variable "codebuild_project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "state_machine_name" {
  type = string
}
