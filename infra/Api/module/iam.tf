
resource "aws_iam_policy" "run_deployer_policy" {
  name        = local.run_deployer_policy_name
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

resource "aws_iam_policy" "register_account_policy" {
  name        = local.register_account_policy_name
  description = "Register Account Policy. Access to cognito and dynamodb"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:Query",
          "dynamodb:PutItem",
          "dynamodb:Query",
        ]
        Effect = "Allow"
        Resource = [
          var.table_arn
        ]
      },
      {
        Action = [
          "cognito-idp:GetUser",
          "cognito-idp:UpdateUserAttributes",
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
  })
}
