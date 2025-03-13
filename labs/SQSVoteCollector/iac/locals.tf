locals {
  infra_bucket                = data.aws_ssm_parameter.state_bucket_name.value
  vote_collector_package_path = "labs/SQSVoteCollector/lambda/${local.vote_collector_lambda_name}.zip"
  vote_generator_package_path = "labs/SQSVoteCollector/lambda/${local.vote_collector_lambda_name}.zip"
  vote_collector_lambda_name  = "VoteCollector"
  vote_generator_lambda_name  = "VoteGenerator"
  voting_queue_name           = "VotingQueue"
  table_name                  = "VotingApp"
}
