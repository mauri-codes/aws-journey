data "aws_iam_policy_document" "ecs_execution_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "role_policy" {
  name   = "TesterLogsPolicy"
  role   = var.task_execution_role_name
  policy = data.aws_iam_policy_document.ecs_execution_policy.json
}
