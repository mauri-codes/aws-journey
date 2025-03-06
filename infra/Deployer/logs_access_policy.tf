resource "aws_iam_policy" "lambda_get_logs" {
  name        = "Get${local.codebuild_project_name}CloudWatchLogs"
  description = "Get Access to Cloudwatch logs in ${local.codebuild_project_name} Codebuild"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:GetLogEvents",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${local.codebuild_project_name}:log-stream:*"
      }
    ]
  })
}
