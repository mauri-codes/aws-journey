module "task_role" {
  source    = "../../z_common/assume_role"
  service   = "ecs-tasks"
  role_name = "${local.app_name}TaskRole"
}

data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    effect = "Allow"
    actions = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
    ]
    resources = [
      var.table_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
        "ecs:UpdateService",
        "ecs:DescribeServices"
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
  statement {
    effect = "Allow"
    actions = [
      "states:SendTaskSuccess",
      "states:SendTaskFailure"
    ]
    resources = [
      "*"
    ]
  }
  
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::*:role/*",
    ]
  }
}

resource "aws_iam_role_policy" "task_role_policy" {
  role   = module.task_role.role_name
  policy = data.aws_iam_policy_document.ecs_task_role_policy.json
}
