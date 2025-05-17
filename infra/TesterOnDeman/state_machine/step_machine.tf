resource "aws_sfn_state_machine" "tester" {
  name     = var.state_machine_name
  role_arn = module.state_machine_role.role_arn
  definition = templatefile("${path.module}/tester.asl.json", {
    TableName           = var.table_name
    ClusterName         = var.cluster_name
    ServiceName         = var.service_name
    QueueUrl            = var.queue_url
    TimeoutMilliseconds = var.timeout_seconds * 1000
    }
  )
}
