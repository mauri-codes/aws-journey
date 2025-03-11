
resource "aws_iam_policy" "run_deployer_policy" {
  name        = "${local.run_deployer_policy_name}"
  description = "Access to Deployer Step Functions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "states:StartExecution"
        ]
        Effect = "Allow"
        Resource = [
          var.step_functions_arn
        ]
      }
    ]
  })
}
