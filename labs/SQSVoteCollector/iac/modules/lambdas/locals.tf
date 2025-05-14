locals {
  vote_collector_lambda_path = var.vote_collector_lambda
  vote_generator_lambda_path = "VoteGenerator"
  vote_collector_lambda_name = "${local.vote_collector_lambda_path}${var.suffix}"
  vote_generator_lambda_name = "${local.vote_generator_lambda_path}${var.suffix}"
  generator_policy_name       = "LambdaSendSQS${var.suffix}"
}
