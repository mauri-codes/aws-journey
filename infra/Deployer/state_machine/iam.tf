module "state_machine_role" {
  source    = "../../z_common/assume_role"
  role_name = "JN_EvaluatorStateMachineRole"
  service   = "states"
  managed_policy_arns = [
    aws_iam_policy.lambda_access.id
  ]
  conditions = {
    "InStateMachine" = {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:states:${var.region}:${var.account_id}:stateMachine:${var.state_machine_name}"
      ]
    }
    "FromAccount" = {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        var.account_id
      ]
    }
  }
}

resource "aws_iam_policy" "lambda_access" {
  name        = "JN_LambdaAccessForStateMachine"
  description = "Access to state machine lambdas"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction"
        ]
        Effect = "Allow"
        Resource = [
          var.start_deployment_lambda_arn,
          var.start_deployment_lambda_arn,
          var.error_handler_lambda_arn
        ]
      },
    ]
  })
}
