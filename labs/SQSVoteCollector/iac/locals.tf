locals {
  infra_bucket                = data.aws_ssm_parameter.state_bucket_name.value
  vote_collector_package_path = "labs/SQSVoteCollector/lambda/${local.vote_collector_lambda_name}.zip"
  vote_generator_package_path = "labs/SQSVoteCollector/lambda/${local.vote_collector_lambda_name}.zip"
  vote_collector_lambda_name  = var.vote_collector_lambda_name
  vote_collector_policy_name  = var.vote_collector_policy_name
  vote_generator_lambda_name  = "VoteGenerator"
  voting_queue_name           = var.voting_queue_name
  table_name                  = var.table_name
  steps = {
    "BASE"           = 0
    "WITH_COLLECTOR" = 1
    "COMPLETE"       = 2
  }
  step = local.steps[var.step]
}
