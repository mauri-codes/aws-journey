resource "aws_iam_policy" "dynamo_put" {
  name        = "DynamoAccess_PUT"
  description = "Access PutItem in DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
        ]
        Effect   = "Allow"
        Resource = var.app_table_arn
      },
    ]
  })
}

resource "aws_iam_policy" "dynamo_delete" {
  name        = "DynamoAccess_DELETE"
  description = "DeleteItem in DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DeleteItem",
        ]
        Effect   = "Allow"
        Resource = var.app_table_arn
      },
    ]
  })
}

resource "aws_iam_policy" "dynamo_get" {
  name        = "DynamoAccess_GET"
  description = "Access GetItem in DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query"
        ]
        Effect   = "Allow"
        Resource = var.app_table_arn
      },
    ]
  })
}
