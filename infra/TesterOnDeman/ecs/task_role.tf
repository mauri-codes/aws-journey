module "task_role" {
  source    = "../../z_common/assume_role"
  service   = "ecs-tasks"
  role_name = "${local.app_name}TaskRole"
}

data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    effect = "Allow"
    actions = [
        "dynamodb:GetItem"
    ]
    resources = [
      var.table_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
        "ecs:UpdateService"
    ]
    resources = [
      aws_ecs_service.app.id
    ]
  }
  statement {
    effect = "Allow"
    actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage"
    ]
    resources = [
      var.queue_arn
    ]
  }
}

resource "aws_iam_role_policy" "task_role_policy" {
  role   = module.task_role.role_name
  policy = data.aws_iam_policy_document.ecs_task_role_policy.json
}
