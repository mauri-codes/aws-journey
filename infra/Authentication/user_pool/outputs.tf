output "user_pool_domain" {
  value = aws_cognito_user_pool_domain.domain.domain
}
output "user_pool_name" {
  value = aws_cognito_user_pool.user_pool.name
}
output "user_pool_arn" {
  value = aws_cognito_user_pool.user_pool.arn
}
output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}
output "user_pool_domain_distribution_arn" {
  value = aws_cognito_user_pool_domain.domain.cloudfront_distribution_arn
}
