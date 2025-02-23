resource "aws_iam_policy" "get_access" {
  name        = "${var.table_label}ReadAccess"
  description = "Read permissions for ${var.table_label}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:DescribeTable"
        ]
        Effect   = "Allow"
        Resource = "${var.table_arn}"
      }
    ]
  })
}

resource "aws_iam_policy" "modify_access" {
  name        = "${var.table_label}ModifyAccess"
  description = "Read and Write permissions for ${var.table_label}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:DescribeTable"
        ]
        Effect   = "Allow"
        Resource = "${var.table_arn}"
      }
    ]
  })
}

resource "aws_iam_policy" "delete_access" {
  name        = "${var.table_label}DeleteAccess"
  description = "Delete permissions for ${var.table_label}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DeleteItem",
        ]
        Effect   = "Allow"
        Resource = "${var.table_arn}"
      }
    ]
  })
}
