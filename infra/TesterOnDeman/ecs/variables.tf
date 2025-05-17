variable "app_name" {
  type = string
}
variable "tester_repo_url" {
  type = string
}
variable "cluster_id" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "table_arn" {
  type = string
}
variable "table_name" {
  type = string
}
variable "task_execution_role_name" {
  type = string
}
variable "task_execution_role_arn" {
  type = string
}
variable "region" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "queue_arn" {
  type = string
}
variable "queue_url" {
  type = string
}
variable "worker_timeout" {
  type = string
}
variable "worker_max_concurrency" {
  type = string
}
