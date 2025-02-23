data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["${var.service}.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    dynamic "condition" {
      for_each = var.conditions
      content {
        test = condition.value.test
        variable = condition.value.variable
        values = condition.value.values
      }
    }
  }
}
resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "extra_policy" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.role.name
  policy_arn = each.key
}
