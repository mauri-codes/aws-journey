
resource "aws_lambda_function" "vote_collector" {
  count            = var.step > 0 ? 1 : 0
  function_name    = local.vote_collector_lambda_name
  role             = module.collector_role[0].role_arn
  timeout          = 10
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  filename         = "/tmp/${local.vote_collector_lambda_path}.zip"
  source_code_hash = filebase64sha256("/tmp/${local.vote_collector_lambda_path}.zip")
  environment {
    variables = {
      APP_TABLE = var.table_name
    }
  }
}

resource "aws_lambda_function" "vote_generator" {
  function_name    = local.vote_generator_lambda_name
  role             = module.generator_role.role_arn
  timeout          = 10
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  filename         = "/tmp/${local.vote_generator_lambda_path}.zip"
  source_code_hash = filebase64sha256("/tmp/${local.vote_generator_lambda_path}.zip")
  environment {
    variables = {
      VOTING_QUEUE_URL = "https://sqs.${var.region}.amazonaws.com/${var.account_id}/${var.voting_queue_name}"
    }
  }
}
