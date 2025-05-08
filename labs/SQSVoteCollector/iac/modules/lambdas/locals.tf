locals {
  vote_collector_lambda_path = "VoteCollector"
  vote_generator_lambda_path = "VoteGenerator"
  vote_collector_lambda_name = "${vote_collector_lambda_path}${var.suffix}"
  vote_generator_lambda_name = "${vote_generator_lambda_path}${var.suffix}"
  generator_policy_name       = "LambdaSendSQS${var.suffix}"
}
