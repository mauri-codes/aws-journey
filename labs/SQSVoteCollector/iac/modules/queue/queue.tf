
resource "aws_sqs_queue" "queue" {
  name                       = var.voting_queue_name
  visibility_timeout_seconds = 60
}

resource "aws_lambda_event_source_mapping" "queue_mapping" {
  event_source_arn                   = aws_sqs_queue.queue.arn
  function_name                      = var.collector_lambda_arn
  batch_size                         = 100
  maximum_batching_window_in_seconds = 5
}

