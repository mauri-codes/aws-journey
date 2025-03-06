module "state_machine_role" {
  source    = "../../z_common/assume_role"
  role_name = "JN_EvaluatorStateMachineRole"
  service   = "states"
  managed_policy_arns = [
    "arn:aws:iam::${var.account_id}:policy/${local.state_machine_policy_name}"
  ]
  conditions = {
  #   "InStateMachine" = {
  #     test     = "ArnLike"
  #     variable = "aws:SourceArn"
  #     values = [
  #       "arn:aws:states:${var.region}:${var.account_id}:stateMachine:${var.state_machine_name}"
  #     ]
  #   }
    "FromAccount" = {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        var.account_id
      ]
    }
  }
  depends_on = [ aws_iam_policy.lambda_access ]
}

resource "aws_iam_policy" "lambda_access" {
  name        = "${local.state_machine_policy_name}"
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
          var.close_deployment_lambda_arn,
          var.error_handler_lambda_arn
        ]
      },
      {
        Action = [
          "codebuild:StartBuild",
          "codebuild:StopBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetReports"
        ]
        Effect = "Allow"
        Resource = [
          var.codebuild_project_arn
        ]
      },
      {
        Action = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:events:${var.region}:${var.account_id}:rule/StepFunctionsGetEventForCodeBuildStartBuildRule"
        ]
      }
    ]
  })
}
