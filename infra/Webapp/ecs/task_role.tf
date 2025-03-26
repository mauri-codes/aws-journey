module "task_role" {
  source    = "../../z_common/assume_role"
  service   = "ecs-tasks"
  role_name = var.ecs_task_role_name
}

data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    effect = "Allow"
    actions = [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:UpdateItem"
    ]
    resources = [
      var.table_arn
    ]
  }
}

resource "aws_iam_role_policy" "task_role_policy" {
  role   = module.task_role.role_name
  policy = data.aws_iam_policy_document.ecs_task_role_policy.json
}
