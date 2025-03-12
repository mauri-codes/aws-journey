locals {
  infra_bucket = data.aws_ssm_parameter.state_bucket_name.value
  vote_collector_package_path = "lab/SQSVoteCollector/lambda/${local.vote_collector_lambda_name}.zip"
  vote_generator_package_path = "lab/SQSVoteCollector/lambda/${local.vote_collector_lambda_name}.zip"
  vote_collector_lambda_name = "VoteCollector"
  vote_generator_lambda_name = "VoteGenerator"
  voting_queue_name = "VotingQueue"

  vote_generator = {
    (local.vote_generator_lambda_name) = {
      handler = "bootstrap"
      s3_key  = "lab/SQSVoteCollector/lambda/${local.vote_generator_lambda_name}.zip"
      environment_variables = {
        VOTING_QUEUE = local.voting_queue_name
      }
      policies = []
      invoke_from = "manual"
    }
  }

  vote_collector = {
    (local.vote_collector_lambda_name) = {
      handler = "bootstrap"
      s3_key  = "lab/SQSVoteCollector/lambda/${local.vote_collector_lambda_name}.zip"
      environment_variables = {
        VOTING_QUEUE = local.voting_queue_name
      }
      policies = [

      ]
      invoke_from = "manual"
    }
  }
  lambda_definitions = var.progress == "BASE" ? local.vote_generator : merge(local.vote_collector, local.vote_generator)
}