output "collector_lambda_arn" {
  value = var.step > 0 ? aws_lambda_function.vote_collector[0].arn : ""
}

output "generator_lambda_arn" {
  value = aws_lambda_function.vote_generator.arn
}
