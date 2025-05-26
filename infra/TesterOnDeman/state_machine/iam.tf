module "state_machine_role" {
  source    = "../../z_common/assume_role"
  role_name = "JN_TesterStateMachineRole"
  service   = "states"
  managed_policy_arns = [
    "arn:aws:iam::${var.account_id}:policy/${local.state_machine_policy_name}"
  ]
  conditions = {
    "FromAccount" = {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        var.account_id
      ]
    }
  }
  depends_on = [aws_iam_policy.lambda_access]
}

resource "aws_iam_policy" "lambda_access" {
  name        = local.state_machine_policy_name
  description = "Permission for Tester state machine"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # {
      #   Action = [
      #     "lambda:InvokeFunction"
      #   ]
      #   Effect = "Allow"
      #   Resource = [
      #     var.start_deployment_lambda_arn,
      #     var.close_deployment_lambda_arn,
      #     var.error_handler_lambda_arn
      #   ]
      # },
      {
        Action = [
          "dynamodb:UpdateItem",
          "dynamodb:GetItem",
          "dynamodb:Query"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${var.table_name}"
        ]
      },
      {
        Action = [
          "ecs:UpdateService"
        ]
        Effect = "Allow"
        Resource = [
          var.service_arn
        ]
      },
      {
        Action = [
          "sqs:SendMessage"
        ]
        Effect = "Allow"
        Resource = [
          var.queue_arn
        ]
      }
    ]
  })
}
