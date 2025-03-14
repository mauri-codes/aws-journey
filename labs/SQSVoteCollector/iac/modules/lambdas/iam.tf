module "generator_logs_policy" {
  source      = "../../../../../infra/z_common/lambda_logs_policy"
  lambda_name = local.vote_generator_lambda_name
}

module "collector_logs_policy" {
  source      = "../../../../../infra/z_common/lambda_logs_policy"
  lambda_name = local.vote_collector_lambda_name
}

module "collector_role" {
  source    = "../../../../../infra/z_common/assume_role"
  role_name = "${local.vote_collector_lambda_name}Role"
  service   = "lambda"
  managed_policy_arns = [
    "arn:aws:iam::${var.account_id}:policy/lambdaLogs_${local.vote_collector_lambda_name}",
    "arn:aws:iam::${var.account_id}:policy/${local.lambda_sqs_policy_name}",
    "arn:aws:iam::${var.account_id}:policy/${local.lambda_dynamo_policy_name}"
  ]
  depends_on = [
    module.generator_logs_policy,
    aws_iam_policy.dynamodb,
    aws_iam_policy.lambda_sqs
  ]
}

module "generator_role" {
  source    = "../../../../../infra/z_common/assume_role"
  role_name = "${local.vote_generator_lambda_name}Role"
  service   = "lambda"
  managed_policy_arns = [
    "arn:aws:iam::${var.account_id}:policy/lambdaLogs_${local.vote_generator_lambda_name}",
    "arn:aws:iam::${var.account_id}:policy/${local.send_sqs_policy_name}"
  ]
  depends_on = [
    module.generator_logs_policy
  ]
}

resource "aws_iam_policy" "lambda_sqs" {
  name        = local.lambda_sqs_policy_name
  description = "Access to SQS for lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:sqs:${var.region}:${var.account_id}:${var.voting_queue_name}"
      },
    ]
  })
}

resource "aws_iam_policy" "send_sqs" {
  name        = local.send_sqs_policy_name
  description = "Send Messages Access to SQS for lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:SendMessage",
          "sqs:SendMessageBatch"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:sqs:${var.region}:${var.account_id}:${var.voting_queue_name}"
      },
    ]
  })
}

resource "aws_iam_policy" "dynamodb" {
  name        = local.lambda_dynamo_policy_name
  description = "Update Access to Voting Table for lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:UpdateItem"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${var.table_name}"
      },
    ]
  })
}
