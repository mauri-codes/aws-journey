output "lambdas_arn" {
  value = {
    for k, lambda in aws_lambda_function.lambda : k => lambda.arn
  }
}