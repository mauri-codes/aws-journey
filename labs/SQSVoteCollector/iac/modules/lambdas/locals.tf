locals {
  vote_collector_lambda_name = "VoteCollector"
  vote_generator_lambda_name = "VoteGenerator"
  lambda_sqs_policy_name     = "LambdaSQSPoll"
  send_sqs_policy_name       = "LambdaSendSQS"
  lambda_dynamo_policy_name  = "DynamoUpdateAccess"
}
