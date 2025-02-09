output "table_name" {
  value = aws_dynamodb_table.user-state.name
}

output "table_arn" {
  value = aws_dynamodb_table.user-state.arn
}
