
module "codebuild_role" {
  source    = "../../z_common/assume_role"
  service   = "codebuild"
  role_name = local.role_name
}

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:DescribeTable"
    ]
    resources = [
      "arn:aws:dynamodb:${local.region}:${local.account_id}:table/${var.app_table}",
      "arn:aws:dynamodb:${local.region}:${local.account_id}:table/${var.state_table}",
      "arn:aws:dynamodb:${local.region}:${local.account_id}:table/${var.user_state_table}"
    ]
  }
  
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketVersioning",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicy"
    ]
    resources = [
      "arn:aws:s3:::${var.state_bucket}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::${var.state_bucket}/*"
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::*:role/*",
    ]
  }
}

resource "aws_iam_role_policy" "role_policy" {
  role   = module.codebuild_role.role_name
  policy = data.aws_iam_policy_document.codebuild_policy.json
}
