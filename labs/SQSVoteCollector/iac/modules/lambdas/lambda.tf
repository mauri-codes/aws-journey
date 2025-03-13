
resource "aws_lambda_function" "vote_collector" {
  function_name    = local.vote_collector_lambda_name
  role             = module.collector_role.role_arn
  timeout          = 10
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  filename         = "${path.module}/${local.vote_collector_lambda_name}.zip"
  source_code_hash = filebase64sha256("${path.module}/${local.vote_collector_lambda_name}.zip")
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
  filename         = "${path.module}/${local.vote_generator_lambda_name}.zip"
  source_code_hash = filebase64sha256("${path.module}/${local.vote_generator_lambda_name}.zip")
  environment {
    variables = {
      VOTING_QUEUE = var.voting_queue_name
    }
  }
}
