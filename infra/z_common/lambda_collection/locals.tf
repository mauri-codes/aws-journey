locals {
  api_gateway_lambdas = { for k, v in var.lambdas_description :  k => v if v.invoke_from == "api_gateway" }
}
