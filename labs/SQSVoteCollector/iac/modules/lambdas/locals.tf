locals {
  vote_collector_lambda_name = "VoteCollector" + var.suffix
  vote_generator_lambda_name = "VoteGenerator" + var.suffix
  generator_policy_name       = "LambdaSendSQS" + var.suffix
}
