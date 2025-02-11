data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["${var.service}.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.policy.json
}
