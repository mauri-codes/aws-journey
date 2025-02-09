resource "aws_s3_bucket" "website_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.public_access.json
  depends_on = [ aws_s3_bucket_public_access_block.public_access ]
}

data "aws_iam_policy_document" "public_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.website_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }

}
