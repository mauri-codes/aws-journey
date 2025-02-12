output "bucket_name" {
  value = aws_s3_bucket.infrastructure.id
}

output "table_name" {
  value = aws_dynamodb_table.aws-journey.name
}

output "table_arn" {
  value = aws_dynamodb_table.aws-journey.arn
}
