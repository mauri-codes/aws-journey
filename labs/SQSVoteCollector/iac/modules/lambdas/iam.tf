module "collector_logs_policy" {
  count       = var.step > 0 ? 1 : 0
  source      = "../../../../../infra/z_common/lambda_logs_policy"
  lambda_name = local.vote_collector_lambda_name
}

module "collector_role" {
  count     = var.step > 0 ? 1 : 0
  source    = "../../../../../infra/z_common/assume_role"
  role_name = var.vote_collector_role_name
  service   = "lambda"
  managed_policy_arns = [
    "arn:aws:iam::${var.account_id}:policy/lambdaLogs_${local.vote_collector_lambda_name}",
    "arn:aws:iam::${var.account_id}:policy/${var.vote_collector_policy_name}",
  ]
  depends_on = [
    module.generator_logs_policy,
    aws_iam_policy.collector
  ]
}

module "generator_logs_policy" {
  source      = "../../../../../infra/z_common/lambda_logs_policy"
  lambda_name = local.vote_generator_lambda_name
}

module "generator_role" {
  source    = "../../../../../infra/z_common/assume_role"
  role_name = "${local.vote_generator_lambda_name}Role"
  service   = "lambda"
  managed_policy_arns = [
    "arn:aws:iam::${var.account_id}:policy/lambdaLogs_${local.vote_generator_lambda_name}",
    "arn:aws:iam::${var.account_id}:policy/${local.generator_policy_name}"
  ]
  depends_on = [
    module.generator_logs_policy,
    aws_iam_policy.generator
  ]
}

resource "aws_iam_policy" "collector" {
  count       = var.step > 0 ? 1 : 0
  name        = var.vote_collector_policy_name
  description = "Permissions for Collector Lambda"

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

resource "aws_iam_policy" "generator" {
  name        = local.generator_policy_name
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
