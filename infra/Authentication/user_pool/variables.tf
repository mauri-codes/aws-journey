variable "user_pool_name" {
  type = string
}
variable "domain" {
  type = string
}
variable "auth_version" {
  type    = string
  default = ""
}
variable "ses_domain_identity" {
  type = string
}
variable "certificate_arn" {
  type = string
}
