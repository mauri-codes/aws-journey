module "lambdas" {
  source                     = "./modules/lambdas"
  voting_queue_name          = local.voting_queue_name
  account_id                 = local.account_A_id
  region                     = local.region_A
  table_name                 = local.table_name
  vote_collector_policy_name = var.vote_collector_policy_name
  step                       = local.step
  suffix                     = var.suffix
  providers = {
    aws = aws.account1_A
  }
}

module "queue" {
  source               = "./modules/queue"
  count                = local.step == 2 ? 1 : 0
  voting_queue_name    = local.voting_queue_name
  collector_lambda_arn = module.lambdas.collector_lambda_arn
  providers = {
    aws = aws.account1_A
  }
}

module "app_table" {
  source         = "./modules/dynamo"
  count          = local.step > 0 ? 1 : 0
  read_capacity  = 5
  write_capacity = 5
  table_name     = local.table_name
  providers = {
    aws = aws.account1_A
  }
}
