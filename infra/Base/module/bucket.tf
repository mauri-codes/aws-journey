resource "aws_s3_bucket" "infrastructure" {
  bucket        = var.bucket_name
  force_destroy = var.bucket_force_destroy
}

resource "aws_s3_bucket_versioning" "infrastructure" {
  bucket = aws_s3_bucket.infrastructure.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = aws_s3_bucket.infrastructure.id

  rule {
    id     = "remove-old-versions"
    status = "Enabled"
    noncurrent_version_expiration {
      newer_noncurrent_versions = 3
      noncurrent_days           = 30
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.infrastructure.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "tls_enforcement" {
  bucket = aws_s3_bucket.infrastructure.id
  policy = data.aws_iam_policy_document.tls_enforcement.json
}

data "aws_iam_policy_document" "tls_enforcement" {
  statement {
    sid    = "EnforcedTLS"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
  statement {
    sid    = "RootAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}
