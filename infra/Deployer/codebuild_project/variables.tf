variable "build_timeout" {
  type = string
}

variable "repo" {
  type = string
}

variable "state_bucket" {
  type = string
}

variable "user_state_table" {
  type = string
}

variable "app_table" {
  type = string
}

variable "state_table" {
  type = string
}

variable "codebuild_image" {
  type = string
}

variable "codebuild_role_name" {
  type = string
}

variable "ecr_repo_arn" {
  type = string
}

variable "codebuild_project_name" {
  type = string
}
