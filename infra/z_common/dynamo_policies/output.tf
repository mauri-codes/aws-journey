output "read_policy_arn" {
  value = aws_iam_policy.get_access.arn
}

output "modify_policy_arn" {
  value = aws_iam_policy.modify_access.arn
}

output "delete_policy_arn" {
  value = aws_iam_policy.delete_access.arn
}
