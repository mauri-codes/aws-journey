variable "zone_id" {
  type = string
}
variable "certificate_arn" {
  type = string
}
variable "certificate_options" {
  type = set(object({
    domain_name=string
    resource_record_name=string
    resource_record_value=string
    resource_record_type=string
  }))
}