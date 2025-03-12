module "lambdas" {
  source            = "./modules/lambdas"
  project_name      = var.project_name
  voting_queue_name = local.voting_queue_name
  account_id        = local.account_A_id
  region            = local.region_A
  depends_on = [
    null_resource.objects
  ]
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

resource "null_resource" "objects" {
  provisioner "local-exec" {
    command = "./packages.sh"
  }
}
