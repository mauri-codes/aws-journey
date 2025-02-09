resource "aws_iam_policy" "lambda_logs" {
  name        = "lambdaLogs_${var.lambda_name}"
  description = "Access to Cloudwatch logs for lambda ${var.lambda_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${local.region}:${local.account_id}:*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/${var.lambda_name}:*"
      },
    ]
  })
}
