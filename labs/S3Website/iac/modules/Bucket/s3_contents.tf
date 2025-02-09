resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  source = "${path.module}/index.html"

  etag = filemd5("${path.module}/index.html")
}
