locals {
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
  api_lambdas = {
    RunDeployer = {
      name    = "RunDeployer"
      handler = "bootstrap"
      policies = [
        aws_iam_policy.dynamo_delete.arn,
        aws_iam_policy.dynamo_put.arn,
        aws_iam_policy.dynamo_get.arn
      ]
    }
    HelloWorld = {
      name    = "HelloWorld"
      handler = "bootstrap"
      policies = [
        aws_iam_policy.dynamo_delete.arn,
        aws_iam_policy.dynamo_get.arn,
        aws_iam_policy.dynamo_put.arn
      ]
    }
  }
}