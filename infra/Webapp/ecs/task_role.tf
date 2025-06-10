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
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
    ]
    resources = [
      var.table_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
        "ssm:GetParameter"
    ]
    resources = [
      var.tester_step_functions_param,
      var.deployer_step_functions_param
    ]
  }
  statement {
    effect = "Allow"
    actions = [
        "states:StartExecution"
    ]
    resources = [
      var.tester_step_functions_arn,
      var.deployer_step_functions_arn
    ]
  }
}

resource "aws_iam_role_policy" "task_role_policy" {
  role   = module.task_role.role_name
  policy = data.aws_iam_policy_document.ecs_task_role_policy.json
}
