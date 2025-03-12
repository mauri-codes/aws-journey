module "lambda_logs_policy" {
  source = "../../../../../infra/z_common/lambda_logs_policy"
  lambda_name = var.project_name
}

module "collector_role" {
  source    = "../../../../../infra/z_common/assume_role"
  role_name = "${local.vote_collector_lambda_name}Role"
  service   = "lambda"
  managed_policy_arns = [
    "arn:aws:iam::${var.account_id}:policy/lambdaLogs_${var.project_name}",
    "arn:aws:iam::${var.account_id}:policy/${local.lambda_sqs_policy_name}"
  ]
}

module "generator_role" {
  source    = "../../../../../infra/z_common/assume_role"
  role_name = "${local.vote_generator_lambda_name}Role"
  service   = "lambda"
  managed_policy_arns = [
    "arn:aws:iam::${var.account_id}:policy/lambdaLogs_${var.project_name}"
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
