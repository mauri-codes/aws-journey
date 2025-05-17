data "aws_iam_policy_document" "ecs_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      var.ecr_repo_arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "role_policy" {
  name   = var.policy_name
  role   = var.role_name
  policy = data.aws_iam_policy_document.ecs_execution_policy.json
}
