output "collector_lambda_arn" {
  value = aws_lambda_function.vote_collector.arn
}

output "generator_lambda_arn" {
  value = aws_lambda_function.vote_generator.arn
}
