module "lambdas" {
  source            = "./modules/lambdas"
  project_name      = var.project_name
  voting_queue_name = local.voting_queue_name
  account_id        = local.account_A_id
  region            = local.region_A
  table_name        = local.table_name
  providers = {
    aws = aws.account1_A
  }
}

module "queue" {
  source               = "./modules/queue"
  voting_queue_name    = local.voting_queue_name
  collector_lambda_arn = module.lambdas.collector_lambda_arn
  providers = {
    aws = aws.account1_A
  }
}

module "app_table" {
  source         = "./modules/dynamo"
  read_capacity  = 5
  write_capacity = 5
  table_name     = local.table_name
  providers = {
    aws = aws.account1_A
  }
}
