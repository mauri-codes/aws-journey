resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.main_vpc.id
  service_name = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids = [aws_route_table.private_rt.id]
  policy = <<POLICY
    {
    "Statement": [
        {
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:DeleteItem"
        ],
        "Effect": "Allow",
        "Resource": "${var.db_table_arn}",
        "Principal": "*"
        }
    ]
    }
    POLICY
  tags = {
    Name = "${var.app_prefix}-dynamo-endpoint"
  }
}