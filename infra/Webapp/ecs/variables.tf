variable "ecr_repo_arn" {
  type = string
}
variable "ecs_execution_role_name" {
  type = string
}
variable "ecs_execution_role_arn" {
  type = string
}
variable "ecs_task_role_name" {
  type = string
}
variable "table_arn" {
  type = string
}
variable "app_name" {
  type = string
}
variable "service_name" {
  type = string
}
variable "alb_id" {
  type = string
}
variable "cluster_id" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "domain_cert_arn" {
  type = string
}
variable "subdomain_cert_arn" {
  type = string
}
variable "webapp_repo_url" {
  type = string
}
variable "domain_name" {
  type = string
}
variable "lb_sg_id" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "region" {
  type = string
}
