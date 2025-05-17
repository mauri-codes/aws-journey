resource "aws_sqs_queue" "tester_queue" {
  name                      = local.app_name
  max_message_size          = 2048
  message_retention_seconds = 300
  receive_wait_time_seconds = 20
}